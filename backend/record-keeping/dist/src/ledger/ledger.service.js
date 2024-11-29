"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.LedgerService = void 0;
const common_1 = require("@nestjs/common");
const db_1 = require("../db");
const schema_1 = require("../db/schema");
const drizzle_orm_1 = require("drizzle-orm");
let LedgerService = class LedgerService {
    async createLedger(createLedgerDto) {
        try {
            const [ledger] = await db_1.db
                .insert(schema_1.ledgerAccount)
                .values(createLedgerDto)
                .returning();
            return ledger;
        }
        catch (error) {
            console.error('Error creating ledger account', error);
            throw new common_1.NotFoundException('Failed to create ledger account');
        }
    }
    async getAllLedgers() {
        try {
            const ledgers = await db_1.db
                .select()
                .from(schema_1.ledgerAccount)
                .execute();
            return ledgers;
        }
        catch (error) {
            console.error('Error fetching ledgers', error);
            throw new common_1.NotFoundException('Failed to fetch ledgers');
        }
    }
    async getLedgerById(id) {
        try {
            const [ledger] = await db_1.db
                .select()
                .from(schema_1.ledgerAccount)
                .where((0, drizzle_orm_1.eq)(schema_1.ledgerAccount.ledgerAccountid, id))
                .execute();
            if (!ledger) {
                throw new common_1.NotFoundException(`Ledger with ID ${id} not found`);
            }
            return ledger;
        }
        catch (error) {
            console.error('Error fetching ledger by ID', error);
            throw new common_1.NotFoundException('Failed to fetch ledger');
        }
    }
    async updateLedger(id, updateLedgerDto) {
        try {
            const [updatedLedger] = await db_1.db
                .update(schema_1.ledgerAccount)
                .set(updateLedgerDto)
                .where((0, drizzle_orm_1.eq)(schema_1.ledgerAccount.ledgerAccountid, id))
                .returning();
            if (!updatedLedger) {
                throw new common_1.NotFoundException(`Ledger with ID ${id} not found`);
            }
            return updatedLedger;
        }
        catch (error) {
            console.error('Error updating ledger', error);
            throw new common_1.NotFoundException('Failed to update ledger');
        }
    }
    async deleteLedger(id) {
        try {
            const [deletedLedger] = await db_1.db
                .delete(schema_1.ledgerAccount)
                .where((0, drizzle_orm_1.eq)(schema_1.ledgerAccount.ledgerAccountid, id))
                .returning();
            if (!deletedLedger) {
                throw new common_1.NotFoundException(`Ledger with ID ${id} not found`);
            }
            return deletedLedger;
        }
        catch (error) {
            console.error('Error deleting ledger', error);
            throw new common_1.NotFoundException('Failed to delete ledger');
        }
    }
};
exports.LedgerService = LedgerService;
exports.LedgerService = LedgerService = __decorate([
    (0, common_1.Injectable)()
], LedgerService);
//# sourceMappingURL=ledger.service.js.map