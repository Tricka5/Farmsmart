import { CreateLedgerEntryDto } from './dto/create-ledger-entry.dto';
import { UpdateLedgerEntryDto } from './dto/update-ledger-entry.dto';
import { LedgerAccountEntryService } from './ledger-entry.service';
export declare class LedgerAccountEntryController {
    private readonly ledgerAccountEntryService;
    constructor(ledgerAccountEntryService: LedgerAccountEntryService);
    createLedgerAccountEntry(createLedgerEntryDto: CreateLedgerEntryDto): Promise<{
        message: string;
        data: {
            date: Date;
            id: number;
            ledgerAccountid: number;
            type: string;
            description: string;
            amount: number;
        };
    }>;
    getAllLedgerEntries(ledgerAccountId: string): Promise<{
        message: string;
        data: {
            date: Date;
            id: number;
            ledgerAccountid: number;
            type: string;
            description: string;
            amount: number;
        }[];
    }>;
    getLedgerEntry(id: string): Promise<{
        message: string;
        data: {
            date: Date;
            id: number;
            ledgerAccountid: number;
            type: string;
            description: string;
            amount: number;
        };
    }>;
    updateLedgerAccountEntry(id: string, updateLedgerEntryDto: UpdateLedgerEntryDto): Promise<{
        message: string;
        data: {
            date: Date;
            id: number;
            ledgerAccountid: number;
            type: string;
            description: string;
            amount: number;
        };
    }>;
    deleteLedgerAccountEntry(id: string): Promise<{
        message: string;
    }>;
}
