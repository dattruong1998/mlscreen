package com.example.recognise;

import android.content.Context;
import android.graphics.Point;
import android.graphics.Rect;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.mlkit.vision.common.InputImage;
import com.google.mlkit.vision.text.Text;
import com.google.mlkit.vision.text.TextRecognition;
import com.google.mlkit.vision.text.TextRecognizer;
import com.google.mlkit.vision.text.latin.TextRecognizerOptions;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static  final String CHANNEL = "ocr";
    private TextRecognizer textRecognizer ;



    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine){
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler(
                (call,result)->{
                    if(call.method.equals("doOcr")){
                        Map<String, Object> imageData = (Map<String, Object>) call.argument("imageData");
                        InputImage inputImage = InputImageConverter.getInputImageFromData(imageData, getContext(), result);

                        if (inputImage == null) return;
                        if(textRecognizer == null)
                            textRecognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS);

                        textRecognizer.process(inputImage)
                                .addOnSuccessListener(new OnSuccessListener<Text>() {
                                    @Override
                                    public void onSuccess(Text text) {
                                        result.success(text.getText());
                                    }
                                })
                                .addOnFailureListener(new OnFailureListener() {
                                    @Override
                                    public void onFailure(@NonNull Exception e) {
                                        result.error("TextDetectorError", e.toString(), null);
                                    }
                                });
                    } else {
                        result.error("UNAVAILABLE","unfound method",null);
                    }
                });
    }

}