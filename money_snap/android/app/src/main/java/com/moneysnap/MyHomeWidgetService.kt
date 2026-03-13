package com.moneysnap

import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService

/**
 * Supplies RemoteViews for each item in the home widget's expense list.
 */
class MyHomeWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return MyHomeWidgetViewsFactory(applicationContext, intent)
    }
}
