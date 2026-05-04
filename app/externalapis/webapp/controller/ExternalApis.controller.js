sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast",
    "sap/m/MessageBox"
], function (Controller, JSONModel, MessageToast, MessageBox) {
    "use strict";

    const SERVICE_URL = "/odata/v4/external-api";

    return Controller.extend("o2c.externalapis.controller.ExternalApis", {

        onInit: function () {
            this.getView().setModel(new JSONModel({
                customers: [],
                products: [],
                customerForm: this._emptyCustomer(),
                productForm: this._emptyProduct(),
                selectedCustomerId: "",
                selectedProductId: ""
            }));

            this.onRefreshCustomers();
            this.onRefreshProducts();
        },

        onHome: function () {
            window.location.href = "/home/webapp/index.html";
        },

        onRefreshCustomers: async function () {
            await this._loadCollection("/ApiCustomers", "/customers", "Customers loaded");
        },

        onRefreshProducts: async function () {
            await this._loadCollection("/ApiProducts", "/products", "Products loaded");
        },

        onCustomerSelect: function (oEvent) {
            this._copySelected(oEvent.getParameter("listItem"), "/customerForm");
        },

        onCustomerRowPress: function (oEvent) {
            this._copySelected(oEvent.getSource(), "/customerForm");
        },

        onProductSelect: function (oEvent) {
            this._copySelected(oEvent.getParameter("listItem"), "/productForm");
        },

        onProductRowPress: function (oEvent) {
            this._copySelected(oEvent.getSource(), "/productForm");
        },

        onSaveCustomer: async function () {
            const data = this._model().getProperty("/customerForm");
            if (!data.CustomerId) {
                MessageBox.error("Customer ID is required.");
                return;
            }

            await this._saveEntity("/ApiCustomers", "CustomerId", data, this._model().getProperty("/selectedCustomerId"));
            await this.onRefreshCustomers();
        },

        onDeleteCustomer: async function () {
            const id = this._model().getProperty("/customerForm/CustomerId");
            await this._deleteEntity("/ApiCustomers", id);
            this.onClearCustomer();
            await this.onRefreshCustomers();
        },

        onClearCustomer: function () {
            this._model().setProperty("/customerForm", this._emptyCustomer());
            this._model().setProperty("/selectedCustomerId", "");
        },

        onSaveProduct: async function () {
            const data = this._model().getProperty("/productForm");
            await this._saveEntity("/ApiProducts", "ProductId", data, this._model().getProperty("/selectedProductId"));
            await this.onRefreshProducts();
        },

        onDeleteProduct: async function () {
            const id = this._model().getProperty("/productForm/ProductId");
            await this._deleteEntity("/ApiProducts", id);
            this.onClearProduct();
            await this.onRefreshProducts();
        },

        onClearProduct: function () {
            this._model().setProperty("/productForm", this._emptyProduct());
            this._model().setProperty("/selectedProductId", "");
        },

        _loadCollection: async function (path, modelPath, successText) {
            try {
                const data = await this._request(path);
                this._model().setProperty(modelPath, data.value || []);
                MessageToast.show(successText);
            } catch (error) {
                MessageBox.error(error.message);
            }
        },

        _saveEntity: async function (collectionPath, keyName, data, selectedKey) {
            try {
                const isUpdate = Boolean(selectedKey);
                const path = isUpdate ? `${collectionPath}('${encodeURIComponent(selectedKey)}')` : collectionPath;
                const payload = Object.assign({}, data);

                if (!isUpdate && keyName === "ProductId") {
                    delete payload.ProductId;
                }

                await this._request(path, {
                    method: isUpdate ? "PATCH" : "POST",
                    headers: {
                        "content-type": "application/json"
                    },
                    body: JSON.stringify(payload)
                });
                MessageToast.show("Saved");
            } catch (error) {
                MessageBox.error(error.message);
            }
        },

        _deleteEntity: async function (collectionPath, id) {
            if (!id) {
                MessageBox.error("Select a row before deleting.");
                return;
            }

            try {
                await this._request(`${collectionPath}('${encodeURIComponent(id)}')`, {
                    method: "DELETE"
                });
                MessageToast.show("Deleted");
            } catch (error) {
                MessageBox.error(error.message);
            }
        },

        _request: async function (path, options) {
            const response = await fetch(`${SERVICE_URL}${path}`, options);
            const text = await response.text();
            const data = text ? JSON.parse(text) : {};

            if (!response.ok) {
                const message = data.error && data.error.message || response.statusText;
                throw new Error(message);
            }

            return data;
        },

        _copySelected: function (listItem, targetPath) {
            const context = listItem && listItem.getBindingContext();
            if (!context) return;

            const data = Object.assign({}, context.getObject());
            this._model().setProperty(targetPath, data);

            if (targetPath === "/customerForm") {
                this._model().setProperty("/selectedCustomerId", data.CustomerId || "");
            }

            if (targetPath === "/productForm") {
                this._model().setProperty("/selectedProductId", data.ProductId || "");
            }
        },

        _model: function () {
            return this.getView().getModel();
        },

        _emptyCustomer: function () {
            return {
                CustomerId: "",
                CustomerName: "",
                Email: "",
                Phone: "",
                Address: "",
                CreditLimit: "",
                UsedCredit: "",
                Status: "Active"
            };
        },

        _emptyProduct: function () {
            return {
                ProductId: "",
                ProductName: "",
                Category: "",
                Price: "",
                Currency: "INR",
                Stock: "",
                Status: "Active"
            };
        }
    });
});
