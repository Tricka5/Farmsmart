"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.LedgerAccountEntryService = void 0;
const common_1 = require("@nestjs/common");
const db_1 = require("../db");
const schema_1 = require("../db/schema");
const drizzle_orm_1 = require("drizzle-orm");
let LedgerAccountEntryService = class LedgerAccountEntryService {
    async createLedgerAccountEntry(data) {
        try {
            const { type, description, amount, ledgerAccountid } = data;
            const [entry] = await db_1.db
                .insert(schema_1.ledgerAccountEntry)
                .values({
                type,
                description,
                amount,
                ledgerAccountid,
            })
                .returning();
            return entry;
        }
        catch (error) {
            console.error('Error creating ledger account entry', error);
            throw new common_1.InternalServerErrorException('Failed to create ledger account entry');
        }
    }
    async findAll(ledgerAccountId) {
        try {
            const entries = await db_1.db
                .select()
                .from(schema_1.ledgerAccountEntry)
                .where((0, drizzle_orm_1.eq)(schema_1.ledgerAccountEntry.ledgerAccountid, ledgerAccountId))
                .groupBy(schema_1.ledgerAccountEntry.type);
            return entries;
        }
        catch (error) {
            console.error('Error fetching ledger entries', error);
            throw new common_1.InternalServerErrorException('Failed to fetch ledger entries');
        }
    }
    async findOne(id) {
        try {
            const numericId = Number(id);
            if (isNaN(numericId)) {
                throw new common_1.NotFoundException('Invalid ledger account entry ID');
            }
            const entries = await db_1.db
                .select()
                .from(schema_1.ledgerAccountEntry)
                .where((0, drizzle_orm_1.eq)(schema_1.ledgerAccountEntry.id, numericId))
                .limit(1);
            if (entries.length === 0) {
                throw new common_1.NotFoundException('Ledger account entry not found');
            }
            return entries[0];
        }
        catch (error) {
            console.error('Error fetching ledger account entry', error);
            throw error instanceof common_1.NotFoundException
                ? error
                : new common_1.InternalServerErrorException('Failed to fetch ledger account entry');
        }
    }
    async updateLedgerAccountEntry(id, data) {
        try {
            const numericId = Number(id);
            if (isNaN(numericId)) {
                throw new common_1.NotFoundException('Invalid ledger account entry ID');
            }
            const existingEntry = await this.findOne(id);
            if (!existingEntry) {
                throw new common_1.NotFoundException('Ledger account entry not found');
            }
            const { type, description, amount, ledgerAccountid } = data;
            const updatedEntry = await db_1.db
                .update(schema_1.ledgerAccountEntry)
                .set({
                type,
                description,
                amount,
                ledgerAccountid,
            })
                .where((0, drizzle_orm_1.eq)(schema_1.ledgerAccountEntry.id, numericId))
                .returning();
            return updatedEntry[0];
        }
        catch (error) {
            console.error('Error updating ledger account entry', error);
            throw new common_1.InternalServerErrorException('Failed to update ledger account entry');
        }
    }
    async deleteLedgerAccountEntry(id) {
        try {
            const numericId = Number(id);
            if (isNaN(numericId)) {
                throw new common_1.NotFoundException('Invalid ledger account entry ID');
            }
            const existingEntry = await this.findOne(id);
            if (!existingEntry) {
                throw new common_1.NotFoundException('Ledger account entry not found');
            }
            await db_1.db
                .delete(schema_1.ledgerAccountEntry)
                .where((0, drizzle_orm_1.eq)(schema_1.ledgerAccountEntry.id, numericId));
            return { message: 'Ledger account entry deleted successfully' };
        }
        catch (error) {
            console.error('Error deleting ledger account entry', error);
            throw new common_1.InternalServerErrorException('Failed to delete ledger account entry');
        }
    }
};
exports.LedgerAccountEntryService = LedgerAccountEntryService;
exports.LedgerAccountEntryService = LedgerAccountEntryService = __decorate([
    (0, common_1.Injectable)()
], LedgerAccountEntryService);
//# sourceMappingURL=ledger-entry.service.js.map