sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel"
], function (Controller, JSONModel) {
    "use strict";

    return Controller.extend("o2c.home.controller.Home", {

        onInit: function () {
            const oData = {
                welcomeTitle: this._getWelcomeTitle()
            };

            this.getView().setModel(new JSONModel(oData));
        },

        onTilePress: function (oEvent) {
            const sTarget = oEvent.getSource().data("target");
            const oRoutes = {
                orders: "/orders/webapp/index.html",
                products: "/products/webapp/index.html",
                customers: "/customers/webapp/index.html",
                orderitems: "/orderitems/webapp/index.html",
                approvals: "/approvals/webapp/index.html",
                invoices: "/invoices/webapp/index.html",
                payments: "/payments/webapp/index.html",
                reports: "/reports/webapp/index.html",
                externalapis: "/externalapis/webapp/index.html",
                analytics: "/analytics/webapp/index.html"
            };

            const sUrl = oRoutes[sTarget];

            if (sUrl) {
                window.location.href = sUrl;
            }
        },

        _getWelcomeTitle: function () {
            const sHour = new Date().getHours();
            const sGreeting = sHour < 12 ? "Good morning" : sHour < 17 ? "Good afternoon" : "Good evening";
            const sName = this._getDisplayName();

            return sName ? `${sGreeting}, ${sName}` : `${sGreeting}, welcome back`;
        },

        _getDisplayName: function () {
            try {
                const oContainer = sap.ushell && sap.ushell.Container;
                const oUserInfo = oContainer && oContainer.getService && oContainer.getService("UserInfo");
                const sName = oUserInfo && (oUserInfo.getFullName() || oUserInfo.getFirstName());
                return sName || "";
            } catch (e) {
                return "";
            }
        }

    });
});
