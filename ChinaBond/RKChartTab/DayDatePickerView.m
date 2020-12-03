//
//  DayDatePickerView.m
//  DayDatePicker
//
//  Created by Hugh Bellamy on 17/01/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//
//  Modified by Robert Miller on 10/09/2015
//  Copyright (c) 2015 Robert Miller. All rights reserved.

#import "DayDatePickerView.h"

@interface DayDatePickerView ()

@property (strong, nonatomic) NSDateComponents *components;

@property (strong, nonatomic) UIView *overlayView;

@property (strong, nonatomic) UIView *selectionIndicator;

@property (assign, nonatomic) NSInteger rowHeight;
@property (assign, nonatomic) NSInteger centralRowOffset;

@end

@implementation DayDatePickerView

@synthesize date = _date;
@synthesize dayDateFormatter = _dayDateFormatter;
@synthesize monthDateFormatter = _monthDateFormatter;
@synthesize yearDateFormatter = _yearDateFormatter;

- (NSString *)daySuffixForDate:(NSDate *)date {
    NSInteger day_of_month = [[self.calendar components:NSCalendarUnitDay fromDate:date] day];
    switch (day_of_month) {
        case 1:
        case 21:
        case 31: return @"st";
        case 2:
        case 22: return @"nd";
        case 3:
        case 23: return @"rd";
        default: return @"th";
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    if(self.daysTableView.superview) {
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(rowHeightForDayDatePickerView:)]) {
        self.rowHeight = [self.delegate rowHeightForDayDatePickerView:self];
    }
    else {
        self.rowHeight = 37;
    }
    self.centralRowOffset = (self.frame.size.height - self.rowHeight) / 2;
    
    CGRect frame = self.bounds;
    if([self.delegate respondsToSelector:@selector(dayDatePickerView:sizeFractionForColumnType:)]) {
        frame.size.width = self.frame.size.width * [self.delegate dayDatePickerView:self sizeFractionForColumnType:DayDatePickerViewColumnTypeDay];
    }
    else {
        frame.size.width = self.frame.size.width * 0.4;
    }
    
    self.daysTableView = [self dayDatePickerTableViewWithFrame:frame type:DayDatePickerViewColumnTypeDay];
    self.daysTableView.bounces = NO;
    [self addSubview:self.daysTableView];
    
    frame.origin.x = frame.size.width;
    if([self.delegate respondsToSelector:@selector(dayDatePickerView:sizeFractionForColumnType:)]) {
        frame.size.width = self.frame.size.width * [self.delegate dayDatePickerView:self sizeFractionForColumnType:DayDatePickerViewColumnTypeMonth];
    }
    else {
        frame.size.width = self.frame.size.width * 0.26;
    }
    self.monthsTableView = [self dayDatePickerTableViewWithFrame:frame type:DayDatePickerViewColumnTypeMonth];
    self.monthsTableView.bounces = NO;
    [self addSubview:self.monthsTableView];
//    self.monthsTableView.backgroundColor = [UIColor yellowColor];

    
    
    if([self.delegate respondsToSelector:@selector(dayDatePickerView:sizeFractionForColumnType:)]) {
        frame.size.width = self.frame.size.width * [self.delegate dayDatePickerView:self sizeFractionForColumnType:DayDatePickerViewColumnTypeMonth];
    }
    else {
        frame.size.width = self.frame.size.width - frame.origin.x - frame.size.width;
    }
    
    frame.origin.x = self.frame.size.width - frame.size.width;
    self.yearsTableView = [self dayDatePickerTableViewWithFrame:frame type:DayDatePickerViewColumnTypeYear];
    self.yearsTableView.bounces = NO;
    [self addSubview:self.yearsTableView];
    
    CGRect dayFrame = self.daysTableView.frame;
    CGRect yearFrame = self.yearsTableView.frame;
    float dayx = yearFrame.origin.x;
    float yearx = dayFrame.origin.x;
    dayFrame.origin.x = dayx;
    yearFrame.origin.x = yearx;
    self.daysTableView.frame = dayFrame;
    self.yearsTableView.frame = yearFrame;

    
    if([self.delegate respondsToSelector:@selector(selectionViewForDayDatePickerView:)]) {
        self.overlayView = [self.delegate selectionViewForDayDatePickerView:self];
    }
    else {
        self.overlayView = [[UIView alloc] init];
        if([self.delegate respondsToSelector:@selector(selectionViewBackgroundColorForDayDatePickerView:)]) {
            self.overlayView.backgroundColor = [self.delegate selectionViewBackgroundColorForDayDatePickerView:self];
        }
        else {
            self.overlayView.backgroundColor = [UIColor clearColor];
        }
        if([self.delegate respondsToSelector:@selector(selectionViewOpacityForDayDatePickerView:)]) {
            self.overlayView.alpha = [self.delegate selectionViewOpacityForDayDatePickerView:self];
        }
        else {
            self.overlayView.alpha = 1;
        }
        self.overlayView.userInteractionEnabled = NO;
    }
    
    
    //年
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.monthsTableView.frame.origin.x-16, 11, 16, 16)];
    yearLabel.text = @"年";
    yearLabel.font = [UIFont systemFontOfSize:16];
    yearLabel.textColor = [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0];
    [self.overlayView addSubview:yearLabel];
    //月
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.daysTableView.frame.origin.x-16, 11, 16, 16)];
    monthLabel.text = @"月";
    monthLabel.font = [UIFont systemFontOfSize:16];
    monthLabel.textColor = [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0];
    [self.overlayView addSubview:monthLabel];
    //日
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-30-16, 11, 16, 16)];
    dayLabel.text = @"日";
    dayLabel.font = [UIFont systemFontOfSize:16];
    dayLabel.textColor = [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0];
    [self.overlayView addSubview:dayLabel];

    CGRect selectionViewFrame = self.bounds;
    selectionViewFrame.origin.y = self.centralRowOffset;
    selectionViewFrame.size.height = self.rowHeight;
    self.overlayView.frame = selectionViewFrame;
    
//    [self.daysTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    [self.monthsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    [self.yearsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self drawLineWithView:self.overlayView y:1];
    [self drawLineWithView:self.overlayView y:self.overlayView.bounds.size.height+0.5];
    
    [self addSubview:self.overlayView];
    
    _calendar = [NSCalendar currentCalendar];
    self.minimumDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.day  = 0;
    offsetComponents.month  = 0;
    offsetComponents.year  = 2;
    self.maximumDate = [calendar dateByAddingComponents:offsetComponents toDate:[NSDate date]options:0];
    [self setDate:[NSDate date] updateComponents:YES];
    
    self.daysTableView.backgroundColor = [UIColor clearColor];
    self.yearsTableView.backgroundColor = [UIColor clearColor];
    self.monthsTableView.backgroundColor = [UIColor clearColor];
}

- (void)drawLineWithView:(UIView *)view y:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, view.bounds.size.width, 1)];
    line.dk_backgroundColorPicker = DKColorWithRGB(0xe9e9e9, 0x323232);//[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
    [view addSubview:line];
}

- (UITableView *)dayDatePickerTableViewWithFrame:(CGRect)frame type:(DayDatePickerViewColumnType)type {
    UITableView *tableView =
    tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    tableView.rowHeight = self.rowHeight;
    tableView.contentInset = UIEdgeInsetsMake(self.centralRowOffset, 0, self.centralRowOffset, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if([self.delegate respondsToSelector:@selector(dayDatePickerView:backgroundColorForColumn:)]) {
        tableView.backgroundColor = [self.delegate dayDatePickerView:self backgroundColorForColumn:type];
    }
    else {
        tableView.backgroundColor = [UIColor whiteColor];
    }
    return tableView;
}

- (void)setDate:(NSDate *)date {
    if([date compare:self.minimumDate] == NSOrderedAscending) {
        [self setDate:self.minimumDate updateComponents:YES];
    }
    else if ([date compare:self.maximumDate] == NSOrderedDescending) {
        [self setDate:self.maximumDate updateComponents:YES];
    }
    else {
        [self setDate:date updateComponents:YES];
    }
}

- (void)setDate:(NSDate *)date updateComponents:(BOOL)updateComponents {
    _date = date;
    if(updateComponents) {
        self.components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
        [self selectRow:self.components.day - 1 inTableView:self.daysTableView animated:YES updateComponents:NO];
        [self selectRow:self.components.month - 1 inTableView:self.monthsTableView animated:YES updateComponents:NO];
        NSDateComponents *minimumDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.minimumDate];
        [self selectRow:self.components.year - minimumDateComponents.year inTableView:self.yearsTableView animated:YES updateComponents:NO];
        [self reload];
    }
    if([self.delegate respondsToSelector:@selector(dayDatePickerView:didSelectDate:)]) {
        [self.delegate dayDatePickerView:self didSelectDate:date];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if(tableView == self.daysTableView) {
        numberOfRows = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date].length;
    }
    else if(tableView == self.monthsTableView) {
        numberOfRows = [self.calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self.date].length;
    }
    else if(tableView == self.yearsTableView) {
        if([self.dataSource respondsToSelector:@selector(numberOfYearsInDayDatePickerView:)]) {
            numberOfRows = [self.dataSource numberOfYearsInDayDatePickerView:self];
        }
        else {
            NSDateComponents *minimumDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.minimumDate];
            //NSDateComponents *todaysDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
            NSDateComponents *maximumDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.maximumDate];
            numberOfRows = (maximumDateComponents.year - minimumDateComponents.year) + 1;
            if (numberOfRows < 1) {
                numberOfRows = 1;
            }
            //numberOfRows = 2;
        }
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:14.0];
    textLabel.textColor = [UIColor blackColor];
    textLabel.tag = 14301;
    textLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
    [cell addSubview:textLabel];
    cell.backgroundColor = [UIColor clearColor];
    
    DayDatePickerViewColumnType columType = DayDatePickerViewColumnTypeDay;
    BOOL disabled = NO;
    
    NSDateComponents *minimumDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.minimumDate];
    NSDateComponents *maximumDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.maximumDate];
    
    NSDateComponents *dateComponents = [self.components copy];
    if(tableView == self.daysTableView) {
        dateComponents.day = indexPath.row + 1;
        NSDate *date = [self.calendar dateFromComponents:dateComponents];
        ((UILabel *)[cell viewWithTag:14301]).frame = CGRectMake(10, 6, self.daysTableView.bounds.size.width-50-16, 26);
        ((UILabel *)[cell viewWithTag:14301]).text = [self.dayDateFormatter stringFromDate:date];
        ((UILabel *)[cell viewWithTag:14301]).backgroundColor = [UIColor clearColor];
        
        if((dateComponents.day < minimumDateComponents.day && dateComponents.month <= minimumDateComponents.month && dateComponents.year <= minimumDateComponents.year) || (dateComponents.day > maximumDateComponents.day && dateComponents.month >= maximumDateComponents.month && dateComponents.year >= maximumDateComponents.year)) {
            disabled = YES;
        }
        columType = DayDatePickerViewColumnTypeDay;
    }
    else if(tableView == self.monthsTableView) {
        dateComponents.day = 1;
        dateComponents.month = indexPath.row + 1;
        NSDate *date = [self.calendar dateFromComponents:dateComponents];
        ((UILabel *)[cell viewWithTag:14301]).text = [self.monthDateFormatter stringFromDate:date];
        ((UILabel *)[cell viewWithTag:14301]).frame = CGRectMake(10, 6, self.monthsTableView.bounds.size.width-20-16, 26);
        cell.backgroundColor = [UIColor clearColor];
        ((UILabel *)[cell viewWithTag:14301]).backgroundColor = [UIColor clearColor];
        
        if((dateComponents.month < minimumDateComponents.month && dateComponents.year <= minimumDateComponents.year) || (dateComponents.month > maximumDateComponents.month && dateComponents.year >= maximumDateComponents.year)) {
            disabled = YES;
        }
        columType = DayDatePickerViewColumnTypeDay;
        
        
    }
    else if(tableView == self.yearsTableView) {
        dateComponents.year = minimumDateComponents.year + indexPath.row;
        NSDate *date = [self.calendar dateFromComponents:dateComponents];
        ((UILabel *)[cell viewWithTag:14301]).text = [self.yearDateFormatter stringFromDate:date];
        ((UILabel *)[cell viewWithTag:14301]).frame = CGRectMake(30, 6, self.yearsTableView.bounds.size.width-40-16, 26);
        ((UILabel *)[cell viewWithTag:14301]).backgroundColor = [UIColor clearColor];
        if(dateComponents.year < minimumDateComponents.year) {
            disabled = YES;
        }
        columType = DayDatePickerViewColumnTypeDay;
        
    }
    
    if([self.delegate respondsToSelector:@selector(dayDatePickerView:fontForRow:inColumn:disabled:)]) {
        cell.textLabel.font = [self.delegate dayDatePickerView:self fontForRow:indexPath.row inColumn:columType disabled:disabled];
    }
    
    if([self.delegate respondsToSelector:@selector(dayDatePickerView:textColorForRow:inColumn:disabled:)]) {
        cell.textLabel.textColor = [self.delegate dayDatePickerView:self textColorForRow:indexPath.row inColumn:columType disabled:disabled];
    }else if(disabled) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    if([self.delegate respondsToSelector:@selector(dayDatePickerView:backgroundColorForRow:inColumn:)]) {
        cell.backgroundColor = [self.delegate dayDatePickerView:self backgroundColorForRow:indexPath.row inColumn:columType];
    }
    
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self alignTableViewToRowBoundary:(UITableView *)scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self alignTableViewToRowBoundary:(UITableView *)scrollView];
}

- (void)alignTableViewToRowBoundary:(UITableView *)tableView {
    const CGPoint relativeOffset = CGPointMake(0, tableView.contentOffset.y + tableView.contentInset.top);
    const NSUInteger row = round(relativeOffset.y / tableView.rowHeight);
    
    [self selectRow:row inTableView:tableView animated:YES updateComponents:YES];
}

- (void)selectRow:(NSInteger)row inTableView:(UITableView *)tableView animated:(BOOL)animated updateComponents:(BOOL)updateComponents {
    const CGPoint alignedOffset = CGPointMake(0, row * tableView.rowHeight - tableView.contentInset.top);
    [tableView setContentOffset:alignedOffset animated:animated];
    
    if(updateComponents) {
        if(tableView == self.daysTableView) {
            self.components.day = row + 1;
        }
        else if(tableView == self.monthsTableView) {
            self.components.month = row + 1;
        }
        else if(tableView == self.yearsTableView) {
            self.components.year = [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate];
            NSDateComponents *minimumDateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.minimumDate];
            self.components.year = minimumDateComponents.year + row;
        }
        [self.components setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        
        self.date = [self.calendar dateFromComponents:self.components];
        [self.daysTableView reloadData];
    }
}

-(NSDate*)getDateFromDateString:(NSString*)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy/MM/d"];
    
    NSDate *date=[dateFormatter dateFromString:dateString];
    
    
    return date;
}

- (void)reload {
    [self.daysTableView reloadData];
    [self.monthsTableView reloadData];
    [self.yearsTableView reloadData];
}

- (NSDateFormatter *)dayDateFormatter {
    if(!_dayDateFormatter) {
        _dayDateFormatter = [[NSDateFormatter alloc]init];
        _dayDateFormatter.dateFormat = @"d";
    }
    return _dayDateFormatter;
}

- (void)setDayDateFormatter:(NSDateFormatter *)dayDateFormatter {
    _dayDateFormatter = dayDateFormatter;
    [self.daysTableView reloadData];
}

- (NSDateFormatter *)monthDateFormatter {
    if(!_monthDateFormatter) {
        _monthDateFormatter = [[NSDateFormatter alloc]init];
        _monthDateFormatter.dateFormat = @"MM";
    }
    return _monthDateFormatter;
}

- (void)setMonthDateFormatter:(NSDateFormatter *)monthDateFormatter {
    _monthDateFormatter = monthDateFormatter;
    [self.monthsTableView reloadData];
}

- (NSDateFormatter *)yearDateFormatter {
    if(!_yearDateFormatter) {
        _yearDateFormatter = [[NSDateFormatter alloc]init];
        _yearDateFormatter.dateFormat = @"yyyy";
    }
    return _yearDateFormatter;
}

- (void)setYearDateFormatter:(NSDateFormatter *)yearDateFormatter {
    _yearDateFormatter = yearDateFormatter;
    [self.yearsTableView reloadData];
}

- (void)setCalendar:(NSCalendar *)calendar {
    _calendar = calendar;
    [self reload];
}

@end
