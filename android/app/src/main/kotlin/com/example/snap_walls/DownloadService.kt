package com.example.snap_walls

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class DownloadService : Service() {

    private val channelId : String = "DownloadServiceChannel"

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Perform your long-running task here
        Thread {
            // Simulate a heavy task
            for (i in 0 until 10) {
                try {
                    Thread.sleep(1000)
                } catch (e: InterruptedException) {
                    e.printStackTrace()
                }
            }
            stopSelf() // Stop the service once the task is complete
        }.start()

        return START_NOT_STICKY
    }


    override fun onCreate() {
        super.onCreate()
        
        createNotificationChannel()

        val notification : Notification = NotificationCompat.Builder(this,channelId)
            .setContentTitle("Downloading")
            .setContentText("Media download")
            .setSmallIcon(R.drawable.launch_background)
            .build()

        startForeground(1,notification)
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                channelId,
                "Foreground Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(serviceChannel)
        }
    }
}