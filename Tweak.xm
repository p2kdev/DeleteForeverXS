@interface PUDeletePhotosActionController : UIViewController <UIAlertViewDelegate>
	-(UIAlertController *)actionSheet;
	- (void)_runDestructiveActionWithCompletion:(id /* block */)arg1;
	- (void)_didCompleteWithDestructiveAction:(BOOL)arg1;
	- (NSArray *)assets;
	-(NSInteger)action;
	- (void)_showOnetimeConfirmation;
	- (void)_handleFinalUserDecisionShouldDelete:(BOOL)arg1;
	- (void)_handleMainAlertConfirmed:(BOOL)arg1;
	- (void)_handleOneTimeAlertConfirmed;
@end

@interface UIAlertController (DeleteForever)
-(void)_dismissWithCancelAction;
@end

%hook PUDeletePhotosActionController

	%new
	-(UIAlertController *)actionSheet {
		return MSHookIvar<id>(self, "__mainAlertController");
	}

	- (void)_setMainAlertController:(id)arg1 {
		%orig;
		if ([self action] == 0)
		{
			UIAlertAction *regularDelete = [[[self actionSheet] actions] objectAtIndex:1];
			NSString *deleteOriginalTitle = [regularDelete title];
			NSString *deleteForeverActionTitle = [NSString stringWithFormat: @"Permanently %@", deleteOriginalTitle];

			UIAlertAction* Delete = [UIAlertAction actionWithTitle:deleteForeverActionTitle style:UIAlertActionStyleDestructive
																										 handler:^(UIAlertAction * action) {
																											MSHookIvar<NSInteger>(self, "_action") = 4;
																											[self _handleMainAlertConfirmed: YES];
																										  [[self actionSheet] dismissViewControllerAnimated:YES completion:nil];
																										}];
			[[self actionSheet] addAction:Delete];
			[[[self actionSheet] performSelector:@selector(_actions)] exchangeObjectAtIndex: 2 withObjectAtIndex: 1];
		}
	}
%end
