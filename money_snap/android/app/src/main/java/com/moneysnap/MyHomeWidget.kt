package com.moneysnap

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class MyHomeWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {}

    override fun onDisabled(context: Context) {}
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val prefs = HomeWidgetPlugin.getData(context)
    val jsonString = prefs.getString(HomeWidgetServiceConstants.KEY_TODAY_EXPENSES, null) ?: "{}"

    val views = RemoteViews(context.packageName, R.layout.my_home_widget)

    // Set total price from saved data
    try {
        val json = org.json.JSONObject(jsonString)
        val totalFormatted = json.optString("totalFormatted", context.getString(R.string.widget_default_total))
        views.setTextViewText(R.id.price_text, totalFormatted)
    } catch (_: Exception) {
        views.setTextViewText(R.id.price_text, context.getString(R.string.widget_default_total))
    }

    // Bind list of expenses to the ListView via RemoteViewsService (unique data URI per widget)
    val serviceIntent = Intent(context, MyHomeWidgetService::class.java)
    serviceIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
    serviceIntent.data = Uri.parse(serviceIntent.toUri(Intent.URI_INTENT_SCHEME))
    views.setRemoteAdapter(R.id.image_list, serviceIntent)

    appWidgetManager.updateAppWidget(appWidgetId, views)
    appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.image_list)
}
