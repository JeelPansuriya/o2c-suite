sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel"
], function (Controller, JSONModel) {
    "use strict";

    return Controller.extend("o2c.home.controller.Home", {

        onInit: function () {

            const oData = {
                kpi: {
                    orders: 1245,
                    products: 512,
                    customers: 328,
                    invoices: 842,
                    payments: 612
                },
                sales: [
                    { month: "Jan", value: 800 },
                    { month: "Feb", value: 920 },
                    { month: "Mar", value: 1050 },
                    { month: "Apr", value: 1180 },
                    { month: "May", value: 1320 }
                ],
                status: [
                    { status: "New", count: 400 },
                    { status: "In Process", count: 300 },
                    { status: "Completed", count: 200 },
                    { status: "Cancelled", count: 100 }
                ]
            };

            this.getView().setModel(new JSONModel(oData));
        },
        
        onTilePress: function (oEvent) {
    const oTile = oEvent.getSource();
    const sTarget = oTile.data("target"); // reads CustomData

    if (sTarget) {
        window.location.href = "/" + sTarget + "/webapp/index.html";
    }
},

        onNavigate: function (oEvent) {
            const sTarget = oEvent.getSource().data("target");

            // Map each tile to app URL
            const oRoutes = {
                orders: "/orders/webapp/index.html",
                products: "/products/webapp/index.html",
                customers: "/customers/webapp/index.html",
                invoices: "/invoices/webapp/index.html",
                payments: "/payments/webapp/index.html"
            };

            const sUrl = oRoutes[sTarget];

            if (sUrl) {
                window.location.href = sUrl;
            }
        }

    });
});