//
//  ViewController.m
//  Smiles
//
//  Created by  Michael Friedman on 2/1/17.
//  Copyright © 2017  Michael Friedman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *trayView;
@property (nonatomic, assign) CGPoint trayOriginalCenter;
@property (nonatomic, assign) CGPoint trayOpenCenter;
@property (nonatomic, assign) CGPoint trayClosedCenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTrayPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    CGPoint translation = [sender translationInView:self.view];

    NSLog(@"location: %@ velocity: %@ translation: %@",
          NSStringFromCGPoint(location),
          NSStringFromCGPoint(velocity),
          NSStringFromCGPoint(translation));


    if (sender.state == UIGestureRecognizerStateBegan) {
        // you have to set these here because of auto-layout and screen sizes. viewDidLoad only picks up size of device used in storyboard
        self.trayOriginalCenter = self.trayView.center;
        self.trayOpenCenter = CGPointMake(self.trayOriginalCenter.x, self.view.bounds.size.height - 108);
        self.trayClosedCenter = CGPointMake(self.trayOriginalCenter.x, self.view.bounds.size.height + 80);

    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if (location.y < self.trayOpenCenter.y) {
            self.trayView.center = self.trayOpenCenter;
        } else if (location.y > self.trayClosedCenter.y) {
            self.trayView.center = self.trayClosedCenter;
        } else {
            self.trayView.center = CGPointMake(self.trayOriginalCenter.x,
                                               self.trayOriginalCenter.y + translation.y);
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        // make stop at top and bottom
        if (location.y <= self.trayOpenCenter.y || velocity.y < 0) {
            [self animateTrayOpen];
        } else if (location.y > self.trayOpenCenter.y || velocity.y > 0) {
            [self animateTrayClosed];
        }
    }
}

- (void) animateTrayOpen {
    [UIView animateWithDuration:1.0 animations:^{
        self.trayView.center = self.trayOpenCenter;
    }];

}

- (void) animateTrayClosed {
    [UIView animateWithDuration:1.0 animations:^{
        self.trayView.center = self.trayClosedCenter;
    }];

}

@end
