package io.github.tsioam.mirror.core

import android.os.Build
import android.os.Bundle
import android.view.KeyEvent
import android.view.WindowManager
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity

const val INTENT_KEY_ADDRESS = "address"
const val INTENT_KEY_PORT = "port"
const val INTENT_KEY_PACKAGE_NAME = "package"
const val INTENT_KEY_DISPLAY = "display"
class SurfaceActivity : AppCompatActivity() {
    private lateinit var mirrorContent: MirrorContent

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val address = intent.getStringExtra(INTENT_KEY_ADDRESS)
        val port = intent.getIntExtra(INTENT_KEY_PORT, -1)
        val packageName = intent.getStringExtra(INTENT_KEY_PACKAGE_NAME)
        enableEdgeToEdge()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            window.attributes.layoutInDisplayCutoutMode =
                WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
        }
        if (address == null || port < 0) {
            setErrorView()
            return
        }

        mirrorContent = MirrorContent(address, port, packageName)
        setContentView(mirrorContent.createView(this))
        mirrorContent.onCreated()
    }

    private fun setErrorView() {

    }

    override fun onPause() {
        super.onPause()
        mirrorContent.onHide()
    }

    override fun onResume() {
        super.onResume()
        mirrorContent.onShow()
    }

    override fun onDestroy() {
        mirrorContent.onDestroy()
        super.onDestroy()
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        return mirrorContent.onKeyDown(keyCode, event)
    }

}