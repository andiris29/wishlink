//
//  ChatListViewController.swift
//  RCloudIMDemo
//
//  Created by Yue Huang on 8/4/15.
//  Copyright (c) 2015 Yue Huang. All rights reserved.
//

import UIKit

class ChatListViewController: RCConversationListViewController {
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad();
        self.prepareData();
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override func willReloadTableData(dataSource: NSMutableArray!) -> NSMutableArray! {
        return dataSource;
    }
    
    override func didReceiveMessageNotification(notification: NSNotification!) {
        
    }
    
    // MARK: - delegate
    
    override func onSelectedTableRow(conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, atIndexPath indexPath: NSIndexPath!) {
        
        if conversationModelType == ._CONVERSATION_MODEL_TYPE_NORMAL {
            var vc = RCConversationViewController(conversationType: .ConversationType_SYSTEM, targetId: "2611");
            vc.userName = "Yeo";
            vc.title = "聊天";
            vc.hidesBottomBarWhenPushed = true;
            self.navigationController!.pushViewController(vc, animated: true);
        }
    }
    
    override func rcConversationListTableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> RCConversationBaseCell! {
        return RCConversationBaseCell(style: .Default, reuseIdentifier: "cell");
    }
    
    // MARK: - response event
    
    // MARK: - prive method
    func prepareData() {
        var dataArray = [RCConversationModel]();
        for _ in 0...3 {
            var c = RCConversationModel();
            c.conversationModelType = ._CONVERSATION_MODEL_TYPE_NORMAL;
            c.conversationType = .ConversationType_PRIVATE;
            c.senderUserId = "49512";
            c.isTop = true;
            c.conversationTitle = "测试数据";
            c.targetId = "2611";
            c.unreadMessageCount = 0;
            c.receivedStatus = RCReceivedStatus.ReceivedStatus_UNREAD;
            c.sentStatus = RCSentStatus.SentStatus_SENT;
            c.receivedTime = Int64(NSDate().timeIntervalSince1970 * 1000);
            c.sentTime = Int64(NSDate().timeIntervalSince1970 * 1000);
            c.objectName = "RC:TxtMsg";
            c.senderUserId = "joke0198";
            c.lastestMessageId = 15;
            var msg = RCTextMessage(content: "测试数据11111111!");
            c.lastestMessage = msg;
            dataArray.append(c);
        }
        self.conversationListDataSource = NSMutableArray(array: dataArray);
    }
    // MARK: - setter and getter
    
    
    
}
