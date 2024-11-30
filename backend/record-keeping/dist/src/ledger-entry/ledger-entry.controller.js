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
exports.LedgerAccountEntryController = void 0;
const common_1 = require("@nestjs/common");
const create_ledger_entry_dto_1 = require("./dto/create-ledger-entry.dto");
const update_ledger_entry_dto_1 = require("./dto/update-ledger-entry.dto");
const ledger_entry_service_1 = require("./ledger-entry.service");
let LedgerAccountEntryController = class LedgerAccountEntryController {
    constructor(ledgerAccountEntryService) {
        this.ledgerAccountEntryService = ledgerAccountEntryService;
    }
    async createLedgerAccountEntry(createLedgerEntryDto) {
        try {
            const newEntry = await this.ledgerAccountEntryService.createLedgerAccountEntry(createLedgerEntryDto);
            return {
                message: 'Ledger account entry created successfully',
                data: newEntry
            };
        }
        catch (error) {
            console.error('Error creating ledger entry', error);
            throw new common_1.HttpException('Failed to create ledger entry', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async getAllLedgerEntries(ledgerAccountId) {
        try {
            console.log("hi1");
            const entries = await this.ledgerAccountEntryService.findAll(ledgerAccountId);
            console.log("hi2");
            return {
                message: 'Ledger account entries fetched successfully',
                data: entries
            };
        }
        catch (error) {
            console.error('Error fetching ledger entries', error);
            throw new common_1.HttpException('Failed to fetch ledger entries', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async getLedgerEntry(id) {
        try {
            const entry = await this.ledgerAccountEntryService.findOne(id);
            if (!entry) {
                throw new common_1.HttpException('Ledger entry not found', common_1.HttpStatus.NOT_FOUND);
            }
            return {
                message: 'Ledger account entry fetched successfully',
                data: entry
            };
        }
        catch (error) {
            console.error('Error fetching ledger entry', error);
            throw new common_1.HttpException('Failed to fetch ledger entry', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async updateLedgerAccountEntry(id, updateLedgerEntryDto) {
        try {
            const updatedEntry = await this.ledgerAccountEntryService.updateLedgerAccountEntry(id, updateLedgerEntryDto);
            if (!updatedEntry) {
                throw new common_1.HttpException('Ledger entry not found', common_1.HttpStatus.NOT_FOUND);
            }
            return {
                message: 'Ledger account entry updated successfully',
                data: updatedEntry
            };
        }
        catch (error) {
            console.error('Error updating ledger entry', error);
            throw new common_1.HttpException('Failed to update ledger entry', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async deleteLedgerAccountEntry(id) {
        try {
            const result = await this.ledgerAccountEntryService.deleteLedgerAccountEntry(id);
            if (!result) {
                throw new common_1.HttpException('Ledger entry not found', common_1.HttpStatus.NOT_FOUND);
            }
            return {
                message: 'Ledger account entry deleted successfully',
            };
        }
        catch (error) {
            console.error('Error deleting ledger entry', error);
            throw new common_1.HttpException('Failed to delete ledger entry', common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
};
exports.LedgerAccountEntryController = LedgerAccountEntryController;
__decorate([
    (0, common_1.Post)('create'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_ledger_entry_dto_1.CreateLedgerEntryDto]),
    __metadata("design:returntype", Promise)
], LedgerAccountEntryController.prototype, "createLedgerAccountEntry", null);
__decorate([
    (0, common_1.Get)('getall/:ledgerAccountId'),
    __param(0, (0, common_1.Param)('ledgerAccountId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], LedgerAccountEntryController.prototype, "getAllLedgerEntries", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], LedgerAccountEntryController.prototype, "getLedgerEntry", null);
__decorate([
    (0, common_1.Put)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, update_ledger_entry_dto_1.UpdateLedgerEntryDto]),
    __metadata("design:returntype", Promise)
], LedgerAccountEntryController.prototype, "updateLedgerAccountEntry", null);
__decorate([
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], LedgerAccountEntryController.prototype, "deleteLedgerAccountEntry", null);
exports.LedgerAccountEntryController = LedgerAccountEntryController = __decorate([
    (0, common_1.Controller)('ledger-entry'),
    __metadata("design:paramtypes", [ledger_entry_service_1.LedgerAccountEntryService])
], LedgerAccountEntryController);
//# sourceMappingURL=ledger-entry.controller.js.map