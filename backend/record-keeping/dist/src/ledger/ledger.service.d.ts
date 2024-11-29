import { CreateLedgerDto } from './dto/create-ledger.dto';
import { UpdateLedgerDto } from './dto/update-ledger.dto';
export declare class LedgerService {
    createLedger(createLedgerDto: CreateLedgerDto): Promise<{
        date: Date;
        ledgerAccountid: number;
        itemname: string;
        transactor: string;
        type: string;
    }>;
    getAllLedgers(): Promise<{
        date: Date;
        ledgerAccountid: number;
        itemname: string;
        transactor: string;
        type: string;
    }[]>;
    getLedgerById(id: number): Promise<{
        date: Date;
        ledgerAccountid: number;
        itemname: string;
        transactor: string;
        type: string;
    }>;
    updateLedger(id: number, updateLedgerDto: UpdateLedgerDto): Promise<{
        date: Date;
        ledgerAccountid: number;
        itemname: string;
        transactor: string;
        type: string;
    }>;
    deleteLedger(id: number): Promise<{
        date: Date;
        ledgerAccountid: number;
        itemname: string;
        transactor: string;
        type: string;
    }>;
}
