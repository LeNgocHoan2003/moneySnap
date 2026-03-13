package com.moneysnap

import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import org.json.JSONObject
import java.io.File
import es.antonborri.home_widget.HomeWidgetPlugin
import com.moneysnap.R

/**
 * Factory that builds RemoteViews for each today's expense item (image + price).
 */
internal class MyHomeWidgetViewsFactory(
    private val context: Context,
    private val intent: Intent
) : RemoteViewsService.RemoteViewsFactory {

    private var items: List<ExpenseItem> = emptyList()
    private var totalFormatted: String = "0đ"

    override fun onCreate() {
        loadData()
    }

    override fun onDataSetChanged() {
        loadData()
    }

    private fun loadData() {
        val prefs = HomeWidgetPlugin.getData(context)
        val jsonString = prefs.getString(HomeWidgetServiceConstants.KEY_TODAY_EXPENSES, null)
            ?: "{}"
        try {
            val json = JSONObject(jsonString)
            totalFormatted = json.optString("totalFormatted", "0đ")
            val arr = json.optJSONArray("items") ?: org.json.JSONArray()
            items = (0 until arr.length()).map { i ->
                val obj = arr.getJSONObject(i)
                ExpenseItem(
                    imagePath = obj.optString("imagePath", ""),
                    amount = obj.optInt("amount", 0)
                )
            }
        } catch (e: Exception) {
            items = emptyList()
            totalFormatted = "0đ"
        }
    }

    override fun getCount(): Int = items.size

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_expense_item)
        val item = items.getOrNull(position) ?: return views

        // Format amount for display (e.g. "50.000đ")
        val amountStr = formatAmount(item.amount)
        views.setTextViewText(R.id.widget_expense_price, amountStr)

        // Load image from app storage if path exists
        if (item.imagePath.isNotEmpty()) {
            try {
                val file = File(item.imagePath)
                if (file.exists()) {
                    val bitmap = BitmapFactory.decodeFile(item.imagePath)
                    if (bitmap != null) {
                        views.setImageViewBitmap(R.id.widget_expense_image, bitmap)
                    }
                }
            } catch (_: Exception) {
                // Leave image empty on error
            }
        }

        return views
    }

    private fun formatAmount(amount: Int): String {
        val abs = kotlin.math.abs(amount)
        if (abs == 0) return "0đ"
        val s = abs.toString().reversed().chunked(3).joinToString(".").reversed()
        return "${s}đ"
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true

    override fun onDestroy() {}
}

private data class ExpenseItem(val imagePath: String, val amount: Int)
