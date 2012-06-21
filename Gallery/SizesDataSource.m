//
//  SizesDataSource.m
//  Gallery
//
//  Created by Chris Bower on 6/18/12.
//  Copyright (c) 2012 Chris Bower Consulting. All rights reserved.
//

#import "SizesDataSource.h"

@implementation SizesDataSource

-(id) init:(NSArray *)data {
    self = [super init];
    if (self) {
        _data = [data retain];
    }
    return self;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [[_data objectAtIndex:indexPath.row] objectForKey:@"title"];
    if ([[[_data objectAtIndex:indexPath.row] objectForKey:@"editions"] isEqualToString:@""]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@ - %@", [[_data objectAtIndex:indexPath.row] objectForKey:@"price"], [[_data objectAtIndex:indexPath.row] objectForKey:@"type"]];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@ - %@ - %@ limited editions", [[_data objectAtIndex:indexPath.row] objectForKey:@"price"], [[_data objectAtIndex:indexPath.row] objectForKey:@"type"], [[_data objectAtIndex:indexPath.row] objectForKey:@"editions"]];
        
    }
    
    // Configure the cell...
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"selectedCategory" object:self userInfo:[_data objectAtIndex:indexPath.row]];
}
-(void)dealloc {
    [_data release];
    [super dealloc];
}
@end
