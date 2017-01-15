import {Component} from '@angular/core';

import {NavController} from 'ionic-angular';
import {BarcodeScanner} from 'ionic-native';

declare var scanner: any;

@Component({
    selector: 'page-about',
    templateUrl: 'about.html'
})
export class AboutPage {

    formats = [
        'AZTEC',
        'CODABAR',
        'CODE_39',
        'CODE_93',
        'CODE_128',
        'DATA_MATRIX',
        'EAN_8',
        'EAN_13',
        'ITF',
        'MAXICODE',
        'PDF_417',
        'QR_CODE',
        'RSS_14',
        'RSS_EXPANDED',
        'UPC_A',
        'UPC_E',
        'UPC_EAN_EXTENSION'
    ];

    constructor(public navCtrl: NavController) {

    }

    scan() {
        BarcodeScanner.scan(
            {
                preferFrontCamera : false, // iOS and Android
                showFlipCameraButton : true, // iOS and Android
                showTorchButton : true, // iOS and Android
                torchOn: true, // Android, launch with the torch switched on (if available)
                prompt : "Place a barcode inside the scan area", // Android
                resultDisplayDuration: 500, // Android, display scanned text for X ms. 0 suppresses it entirely, default 1500
                formats : "UPC_E,UPC_A", // default: all but PDF_417 and RSS_EXPANDED
                orientation : "portrait", // Android only (portrait|landscape), default unset so it rotates with the device
                disableAnimations : true // iOS
            }
        ).then(
            function (result) {
                alert("We got a barcode\n" +
                    "Result: " + result.text + "\n" +
                    "Format: " + result.format + "\n" +
                    "Cancelled: " + result.cancelled);
            },
            function (error) {
                alert("Scanning failed: " + error);
            });
    }

    close() {
        // scanner.close();
    }

    flash() {
        // scanner.toggleFlash();
    }
}
