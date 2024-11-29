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
exports.LedgerController = void 0;
const common_1 = require("@nestjs/common");
const ledger_service_1 = require("./ledger.service");
const create_ledger_dto_1 = require("./dto/create-ledger.dto");
const update_ledger_dto_1 = require("./dto/update-ledger.dto");
let LedgerController = class LedgerController {
    constructor(ledgerService) {
        this.ledgerService = ledgerService;
    }
    async createLedger(createLedgerDto) {
        console.log('create');
        try {
            const result = await this.ledgerService.createLedger(createLedgerDto);
            return {
                message: 'Ledger account created successfully',
                data: result,
            };
        }
        catch (error) {
            console.error('Error creating ledger account', error);
            throw new common_1.HttpException('Failed to create ledger account', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async getAllLedgers() {
        try {
            const ledgers = await this.ledgerService.getAllLedgers();
            return {
                message: 'Fetched all ledgers successfully',
                data: ledgers,
            };
        }
        catch (error) {
            console.error('Error fetching ledgers', error);
            throw new common_1.HttpException('Failed to fetch ledgers', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async getLedgerById(id) {
        try {
            const ledger = await this.ledgerService.getLedgerById(id);
            if (!ledger) {
                throw new common_1.HttpException('Ledger not found', common_1.HttpStatus.NOT_FOUND);
            }
            return {
                message: 'Fetched ledger successfully',
                data: ledger,
            };
        }
        catch (error) {
            console.error('Error fetching ledger by ID', error);
            throw new common_1.HttpException('Failed to fetch ledger', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async updateLedger(id, updateLedgerDto) {
        try {
            const updatedLedger = await this.ledgerService.updateLedger(id, updateLedgerDto);
            if (!updatedLedger) {
                throw new common_1.HttpException('Ledger not found', common_1.HttpStatus.NOT_FOUND);
            }
            return {
                message: 'Ledger updated successfully',
                data: updatedLedger,
            };
        }
        catch (error) {
            console.error('Error updating ledger', error);
            throw new common_1.HttpException('Failed to update ledger', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async deleteLedger(id) {
        try {
            const deletedLedger = await this.ledgerService.deleteLedger(id);
            if (!deletedLedger) {
                throw new common_1.HttpException('Ledger not found', common_1.HttpStatus.NOT_FOUND);
            }
            return {
                message: 'Ledger deleted successfully',
                data: deletedLedger,
            };
        }
        catch (error) {
            console.error('Error deleting ledger', error);
            throw new common_1.HttpException('Failed to delete ledger', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
};
exports.LedgerController = LedgerController;
__decorate([
    (0, common_1.Post)('create'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_ledger_dto_1.CreateLedgerDto]),
    __metadata("design:returntype", Promise)
], LedgerController.prototype, "createLedger", null);
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], LedgerController.prototype, "getAllLedgers", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], LedgerController.prototype, "getLedgerById", null);
__decorate([
    (0, common_1.Put)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, update_ledger_dto_1.UpdateLedgerDto]),
    __metadata("design:returntype", Promise)
], LedgerController.prototype, "updateLedger", null);
__decorate([
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], LedgerController.prototype, "deleteLedger", null);
exports.LedgerController = LedgerController = __decorate([
    (0, common_1.Controller)('ledger'),
    __metadata("design:paramtypes", [ledger_service_1.LedgerService])
], LedgerController);
//# sourceMappingURL=ledger.controller.js.map