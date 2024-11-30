import { insertInboxParticipants, selectInboxParticpants, selectUsers } from 'src/db/schema';
export declare class InboxparticipantsService {
    addParticipant(data: insertInboxParticipants): Promise<{
        inboxid: number;
        firstuserid: number;
        seconduserid: number;
    }>;
    catch(error: any): void;
    getInboxParticipant(userId: selectInboxParticpants['firstuserid']): Promise<selectInboxParticpants | null>;
    getAllinbox(ids: number[]): Promise<selectInboxParticpants[] | null>;
    getUserFromUsersTable(userids: number[]): Promise<selectUsers[] | null>;
    getCurrentInbox(otheruser: number, currentuser: number): Promise<{
        inboxid: number;
    }>;
    getFriends(id: number): Promise<{
        secondinboxid: number;
    }[]>;
}
