import { insertInboxParticipants, selectInboxParticpants, selectUsers } from 'src/db/schema';
export declare class InboxparticipantsService {
    addParticipant(data: insertInboxParticipants): Promise<{
        userid: number;
        inboxid: number;
    }>;
    catch(error: any): void;
    getInboxParticipant(userId: selectInboxParticpants['userid']): Promise<selectInboxParticpants | null>;
    getAllinbox(ids: number[]): Promise<selectInboxParticpants[] | null>;
    getUsers(ids: number[]): Promise<selectInboxParticpants[] | null>;
    getUserFromUsersTable(userids: number[], userIdCurrent: number): Promise<selectUsers[] | null>;
    getCurrentInbox(otheruser: number, currentuser: number): Promise<{
        inboxid: number;
    }[]>;
}
