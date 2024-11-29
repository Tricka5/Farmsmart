import { CreateLedgerEntryDto } from './dto/create-ledger-entry.dto';
import { UpdateLedgerEntryDto } from './dto/update-ledger-entry.dto';
export declare class LedgerAccountEntryService {
    createLedgerAccountEntry(data: CreateLedgerEntryDto): Promise<{
        date: Date;
        id: number;
        ledgerAccountid: number;
        type: string;
        description: string;
        amount: number;
    }>;
    findAll(ledgerAccountId: any): Promise<{
        date: Date;
        id: number;
        ledgerAccountid: number;
        type: string;
        description: string;
        amount: number;
    }[]>;
    findOne(id: string): Promise<{
        date: Date;
        id: number;
        ledgerAccountid: number;
        type: string;
        description: string;
        amount: number;
    }>;
    updateLedgerAccountEntry(id: string, data: UpdateLedgerEntryDto): Promise<{
        date: Date;
        id: number;
        ledgerAccountid: number;
        type: string;
        description: string;
        amount: number;
    }>;
    deleteLedgerAccountEntry(id: string): Promise<{
        message: string;
    }>;
}
