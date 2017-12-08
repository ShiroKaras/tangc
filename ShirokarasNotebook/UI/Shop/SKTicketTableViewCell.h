//
//  SKTicketTableViewCell.h
//  ShirokarasNotebook
//
//  Created by SinLemon on 2017/11/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKTicketTableViewCell : UITableViewCell
@property (nonatomic, strong) SKTicket *ticket;
@property (nonatomic, assign) float cellHeight;
@end
