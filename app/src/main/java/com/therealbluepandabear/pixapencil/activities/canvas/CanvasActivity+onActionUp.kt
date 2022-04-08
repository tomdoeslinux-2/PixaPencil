package com.therealbluepandabear.pixapencil.activities.canvas

import com.therealbluepandabear.pixapencil.R
import com.therealbluepandabear.pixapencil.algorithms.PixelPerfectAlgorithm
import com.therealbluepandabear.pixapencil.database.BrushesDatabase
import com.therealbluepandabear.pixapencil.enums.ToolFamily
import com.therealbluepandabear.pixapencil.enums.Tools
import com.therealbluepandabear.pixapencil.extensions.disable
import com.therealbluepandabear.pixapencil.extensions.enable

fun extendedOnActionUp() {
    when {
        currentTool == Tools.LineTool -> {
            lineToolOnActionUp()
        }

        currentTool.toolFamily == ToolFamily.Rectangle -> {
            rectangleToolOnActionUp()
        }

        currentTool == Tools.PolygonTool -> {
            outerCanvasInstance.canvasFragment.pixelGridViewInstance.bitmapActionData.add(
                outerCanvasInstance.canvasFragment.pixelGridViewInstance.currentBitmapAction!!
            )
        }

        currentTool.toolFamily == ToolFamily.Circle -> {
            circleToolOnActionUp()
        }

        currentTool == Tools.EraseTool -> {
            primaryAlgorithmInfoParameter.color = getSelectedColor()
        }

        else -> {
            outerCanvasInstance.canvasFragment.pixelGridViewInstance.bitmapActionData.add(outerCanvasInstance.canvasFragment.pixelGridViewInstance.currentBitmapAction!!)

            if (outerCanvasInstance.canvasFragment.pixelGridViewInstance.pixelPerfectMode
                && (currentTool == Tools.PencilTool)
                && (outerCanvasInstance.canvasFragment.pixelGridViewInstance.currentBrush == null || outerCanvasInstance.canvasFragment.pixelGridViewInstance.currentBrush == BrushesDatabase.toList().first())) {
                val pixelPerfectAlgorithmInstance = PixelPerfectAlgorithm(primaryAlgorithmInfoParameter)
                pixelPerfectAlgorithmInstance.compute()
            }

            outerCanvasInstance.canvasFragment.pixelGridViewInstance.prevX = null
            outerCanvasInstance.canvasFragment.pixelGridViewInstance.prevY = null
        }
    }

    if (outerCanvasInstance.canvasFragment.pixelGridViewInstance.bitmapActionData.isNotEmpty() && currentTool.draws) {
        menu.findItem(R.id.activityCanvasTopAppMenu_undo).enable()
    }

    if (outerCanvasInstance.canvasFragment.pixelGridViewInstance.undoStack.isEmpty()) {
        menu.findItem(R.id.activityCanvasTopAppMenu_redo_item).disable()
    }

    outerCanvasInstance.canvasFragment.pixelGridViewInstance.currentBitmapAction = null
}