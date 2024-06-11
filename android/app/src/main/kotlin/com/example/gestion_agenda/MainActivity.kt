package com.example.Agenda_Management
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.jakewharton.threetenabp.AndroidThreeTen

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AndroidThreeTen.init(this)
    }
}
