//
//  ViewController.m
//  MiPrimeraTabla
//
//  Created by Roberto Alvarez on 20/09/17.
//  Copyright © 2017 Roberto Alvarez. All rights reserved.
//

#import "ViewController.h"
#import "cellMainTable.h"
#import "DetailViewController.h"

@interface ViewController ()
@property NSMutableArray *heroNames;
@property NSMutableArray *heroImgs;
@property NSMutableArray *heroages;

@property (weak, nonatomic) IBOutlet UITableView *tblHeroes;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initController{
    self.heroNames = [[NSMutableArray alloc] initWithObjects: @"Tyrion Lannister", @"Daenerys Targareyan", @"Jon snow", @"Arya Stark", @"Cersei Lannister", nil];
    
    self.heroImgs = [[NSMutableArray alloc] initWithObjects: @"tyrion.jpg", @"daenerys.jpg", @"jon.jpg", @"aryastark.jpg", @"cersei.jpg", nil];
    
    self.heroages = [[NSMutableArray alloc] initWithObjects: @"30", @"27", @"24", @"20", @"40", nil];
    
}


//-----------------------------------------
//Table functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//-------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.heroNames.count;
}
//-------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
//-------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Initialize cells
    cellMainTable *cell = (cellMainTable *)[tableView dequeueReusableCellWithIdentifier:@"cellMainTable"];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"cellMainTable" bundle:nil] forCellReuseIdentifier:@"cellMainTable"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellMainTable"];
    }
    //Fill cell with info from arrays
    cell.nameHero.text       = self.heroNames[indexPath.row];
    cell.imgHero.image  = [UIImage imageNamed:self.heroImgs[indexPath.row]];
    cell.ageHero.text        = self.heroages[indexPath.row];
    
    return cell;
}

//-------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     NSLog(@"you pressed a row");
    [self performSegueWithIdentifier:@"viewDetailsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"viewDetailsSegue"])
    {
        //if you need to pass data to the next controller do it here
        
        NSIndexPath *path = [self.tblHeroes indexPathForSelectedRow];
        DetailViewController *vc;
        vc = [segue destinationViewController];
        vc.lbl1.text = @"Roberto";
        vc.imgViewDetail.image = [UIImage imageNamed:self.heroImgs[path.row]];
       
    }
}

- (IBAction)btnAdd:(id)sender {
    
    /*
     
     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter Text"
     message:@"Enter some text below"
     preferredStyle:UIAlertViewStylePlainTextInput];
     
     UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault
     handler:^(UIAlertAction * action) {
     
     if (alert.textFields.count > 0) {
     
     UITextField *textField = [alert.textFields firstObject];
     
     UITextField *textField2 = [alert.textFields firstObject];
     
     // textField.text // your text
     }
     
     }];
*/
    int lastIndex = [self.heroNames count];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game of thrones"
                                                                   message:@"Ingrese la informacion del nuevo heroe"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
     
                                                       if (alert.textFields.count > 0) {
     
                                                           UITextField *textFieldName = [alert.textFields objectAtIndex:0];
                                                           
                                                           UITextField *textFieldAge = [alert.textFields objectAtIndex:1];
                                                           
                                                           
                                                           [self.heroNames insertObject:textFieldName.text atIndex:lastIndex];
                                                           [self.heroages insertObject:textFieldAge.text atIndex:lastIndex];
                                                           [self.heroImgs insertObject:@"jon.jpg"atIndex:lastIndex];
                                                           [self.tblHeroes reloadData];
                                                       }
                                                       
                                                   }];
    
    UIAlertAction *photoPicker = [UIAlertAction actionWithTitle:@"Foto" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       if (alert.textFields.count > 0) {
                                                           NSLog(@"you pressed Yes, please button Roberto");
                                                       }
                                                       
                                                      [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
                                                       
                                                      [self presentViewController: alert animated:YES completion:nil];
                                                       
                                                   }];
    
    [alert addAction:submit];
    
    [alert addAction:photoPicker];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Ingresar nombre";
    }];
    
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Ingresar edad";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
   /* [self.heroNames addObject:@"Walter"];
    [self.heroages addObject:@"37 años"];
    [self.heroImgs addObject:@"jon.jpg"];
    [self.tblHeroes reloadData];*/
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    self.heroeURL = [info objectForKey:UIImagePickerControllerMediaURL];

    int lastIndex = [self.heroNames count] -1;
    [self.heroImgs insertObject:self.heroeURL.absoluteString atIndex:lastIndex];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  -

- (void)getMediaFromSource: (UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    
    if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *deviceNotFoundAlert = [[UIAlertView alloc] initWithTitle:@"No Device" message:@"Camera is not available"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Okay"
                                                            otherButtonTitles:nil];
        [deviceNotFoundAlert show];
        
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing =  YES;
        picker.sourceType = sourceType;
        [self presentViewController: picker animated:YES completion:nil];

    }
    
}





@end

