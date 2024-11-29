"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CashBookController = void 0;
const common_1 = require("@nestjs/common");
const cash_book_service_1 = require("./cash-book.service");
const create_cash_book_dto_1 = require("./dto/create-cash-book.dto");
const update_cash_book_dto_1 = require("./dto/update-cash-book.dto");
let CashBookController = class CashBookController {
    constructor(cashBookService) {
        this.cashBookService = cashBookService;
    }
    create(createCashBookDto) {
        return this.cashBookService.create(createCashBookDto);
    }
    findAll() {
        return this.cashBookService.findAll();
    }
    findOne(id) {
        return this.cashBookService.findOne(+id);
    }
    update(id, updateCashBookDto) {
        return this.cashBookService.update(+id, updateCashBookDto);
    }
    remove(id) {
        return this.cashBookService.remove(+id);
    }
};
exports.CashBookController = CashBookController;
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_cash_book_dto_1.CreateCashBookDto]),
    __metadata("design:returntype", void 0)
], CashBookController.prototype, "create", null);
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], CashBookController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], CashBookController.prototype, "findOne", null);
__decorate([
    (0, common_1.Patch)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, update_cash_book_dto_1.UpdateCashBookDto]),
    __metadata("design:returntype", void 0)
], CashBookController.prototype, "update", null);
__decorate([
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], CashBookController.prototype, "remove", null);
exports.CashBookController = CashBookController = __decorate([
    (0, common_1.Controller)('cash-book'),
    __metadata("design:paramtypes", [cash_book_service_1.CashBookService])
], CashBookController);
//# sourceMappingURL=cash-book.controller.js.map