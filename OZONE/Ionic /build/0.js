webpackJsonp([0],{

/***/ 938:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "ModalLanguagesPageModule", function() { return ModalLanguagesPageModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1_ionic_angular__ = __webpack_require__(7);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__ngx_translate_core__ = __webpack_require__(55);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__modal_languages__ = __webpack_require__(939);
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};




var ModalLanguagesPageModule = /** @class */ (function () {
    function ModalLanguagesPageModule() {
    }
    ModalLanguagesPageModule = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["I" /* NgModule */])({
            declarations: [
                __WEBPACK_IMPORTED_MODULE_3__modal_languages__["a" /* ModalLanguagesPage */]
            ],
            imports: [
                __WEBPACK_IMPORTED_MODULE_1_ionic_angular__["h" /* IonicPageModule */].forChild(__WEBPACK_IMPORTED_MODULE_3__modal_languages__["a" /* ModalLanguagesPage */]), __WEBPACK_IMPORTED_MODULE_2__ngx_translate_core__["b" /* TranslateModule */]
            ]
        })
    ], ModalLanguagesPageModule);
    return ModalLanguagesPageModule;
}());

//# sourceMappingURL=modal-languages.module.js.map

/***/ }),

/***/ 939:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return ModalLanguagesPage; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__ngx_translate_core__ = __webpack_require__(55);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_ionic_angular__ = __webpack_require__(7);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__services_translate_translate__ = __webpack_require__(23);
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};




var ModalLanguagesPage = /** @class */ (function () {
    function ModalLanguagesPage(translate, view, translateWrapper) {
        this.translate = translate;
        this.view = view;
        this.translateWrapper = translateWrapper;
        var browserLanguage = localStorage.getItem('language') || translate.getBrowserLang();
        translate.setDefaultLang(browserLanguage);
    }
    ModalLanguagesPage.prototype.switchLanguage = function (language) {
        this.translate.use(language);
        this.translateWrapper.shouldReloadPrograms = true;
        localStorage.setItem('language', language);
    };
    ModalLanguagesPage.prototype.ionViewDidLoad = function () { };
    ModalLanguagesPage.prototype.closeModal = function () {
        this.view.dismiss();
    };
    ModalLanguagesPage = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["m" /* Component */])({
            selector: 'page-modal-languages',template:/*ion-inline-start:"/Users/kevinbaldha/Desktop/Techvoot/Projects/LiveProject/IonicProjects/Orgill-Ionic-new_services/src/pages/settings/modal-languages/modal-languages.html"*/'<ion-header>\n    <ion-navbar>\n            <ion-buttons right>\n                <button id="closeBtn" ion-button icon-only (click)="closeModal()">\n                    {{"close" | translate}} \n                </button>\n            </ion-buttons>\n    </ion-navbar>\n</ion-header>\n\n<ion-content padding>\n    <ion-list radio-group>\n        <ion-item>\n                    <ion-label>English</ion-label>\n                    <ion-radio [checked]="translate.currentLang == \'en\'"  (click)="switchLanguage(\'en\')"></ion-radio>\n        </ion-item>\n        <ion-item>\n                    <ion-label>French</ion-label>\n                    <ion-radio [checked]="translate.currentLang == \'fr\'" (click)="switchLanguage(\'fr\')"></ion-radio>\n        </ion-item>\n    </ion-list>\n</ion-content>'/*ion-inline-end:"/Users/kevinbaldha/Desktop/Techvoot/Projects/LiveProject/IonicProjects/Orgill-Ionic-new_services/src/pages/settings/modal-languages/modal-languages.html"*/
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__ngx_translate_core__["c" /* TranslateService */],
            __WEBPACK_IMPORTED_MODULE_2_ionic_angular__["r" /* ViewController */],
            __WEBPACK_IMPORTED_MODULE_3__services_translate_translate__["a" /* TranslateWrapperService */]])
    ], ModalLanguagesPage);
    return ModalLanguagesPage;
}());

//# sourceMappingURL=modal-languages.js.map

/***/ })

});
//# sourceMappingURL=0.js.map