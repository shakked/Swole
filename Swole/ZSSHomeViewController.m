//
//  ZSSHomeViewController.m
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import "ZSSHomeViewController.h"

@interface ZSSHomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *chestButton;
@property (weak, nonatomic) IBOutlet UIButton *legsButton;
@property (weak, nonatomic) IBOutlet UIButton *absButton;
@property (weak, nonatomic) IBOutlet UIButton *shouldersButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *cardioButton;

@property (nonatomic, strong) NSArray *workOutButtons;

@end

@implementation ZSSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

- (void)configureViews {
    self.workOutButtons = @[self.chestButton, self.legsButton, self.absButton, self.shouldersButton, self.backButton, self.cardioButton];
    for (UIButton *button in self.workOutButtons) {
        button.layer.cornerRadius = 37;
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(2, 2);
    }
}

- (IBAction)chestButtonPressed:(id)sender {
}

- (IBAction)legsButtonPressed:(id)sender {
}

- (IBAction)absButtonPressed:(id)sender {
}

- (IBAction)shouldersButtonPressed:(id)sender {
}

- (IBAction)backButtonPressed:(id)sender {
}

- (IBAction)cardioButtonPressed:(id)sender {
    
}

@end
