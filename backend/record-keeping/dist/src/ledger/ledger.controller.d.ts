import { LedgerService } from './ledger.service';
import { CreateLedgerDto } from './dto/create-ledger.dto';
import { UpdateLedgerDto } from './dto/update-ledger.dto';
export declare class LedgerController {
    private readonly ledgerService;
    constructor(ledgerService: LedgerService);
    createLedger(createLedgerDto: CreateLedgerDto): Promise<{
        message: string;
        data: {
            date: Date;
            ledgerAccountid: number;
            itemname: string;
            transactor: string;
            type: string;
        };
    }>;
    getAllLedgers(): Promise<{
        message: string;
        data: {
            date: Date;
            ledgerAccountid: number;
            itemname: string;
            transactor: string;
            type: string;
        }[];
    }>;
    getLedgerById(id: number): Promise<{
        message: string;
        data: {
            date: Date;
            ledgerAccountid: number;
            itemname: string;
            transactor: string;
            type: string;
        };
    }>;
    updateLedger(id: number, updateLedgerDto: UpdateLedgerDto): Promise<{
        message: string;
        data: {
            date: Date;
            ledgerAccountid: number;
            itemname: string;
            transactor: string;
            type: string;
        };
    }>;
    deleteLedger(id: number): Promise<{
        message: string;
        data: {
            date: Date;
            ledgerAccountid: number;
            itemname: string;
            transactor: string;
            type: string;
        };
    }>;
}
