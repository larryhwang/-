//
//  UserInfoBasic.m
//  清房助手
//
//  Created by Larry on 12/31/15.
//  Copyright © 2015 HuiZhou S&F NetworkTechCo.,Ltd . All rights reserved.
//

#import "UserInfoBasic.h"
#import "UIImageView+WebCache.h"
#import "QBImagePickerController.h"
#import <Photos/Photos.h>
#import "AppDelegate.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "MBProgressHUD+CZ.h"

@interface UserInfoBasic ()<UIActionSheetDelegate,QBImagePickerControllerDelegate>
@property (strong, nonatomic)  UIImageView *iCoView;

@property (weak, nonatomic)  UILabel *QFuserName;

@property (weak, nonatomic)  UILabel *QFcompanyName;

@property (weak, nonatomic)  UILabel *QFuserID;

@property (weak, nonatomic)  UILabel *QFSex;

@property (weak, nonatomic)  UILabel *QFminzu;

@property (weak, nonatomic)  UILabel *QFbirthDate;

@property (weak, nonatomic)  UILabel *QFemail;

@property (weak, nonatomic)  UILabel *QFregion;

@end

@implementation UserInfoBasic

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iCoView.layer.cornerRadius = 25;
    self.iCoView.layer.masksToBounds = YES;
    self.navigationController.navigationBarHidden = YES;
}

/**
 *  更新数据
 */
-(void)displayDataFromNet {
    //头像数据获取
    self.iCoView.image = [UIImage imageNamed:@"head"]; //urlStr	__NSCFString *	@"http://www.123qf.cn/portrait/15018639039/hsf_20160229100243_1.jpg"	0x0000000158263460
    NSString *urlStr = [NSString stringWithFormat:@"http://www.123qf.cn/portrait/%@/%@",self.QFDataDic[@"userid"],self.QFDataDic[@"portrait"]];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.iCoView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         self.iCoView.image = image;
    }];
    //姓名
    self.QFuserName.text = self.QFDataDic[@"username"];
    //公司
    self.QFcompanyName.text = self.QFDataDic[@"name"];
    //手机号
    self.QFuserID.text =self.QFDataDic[@"tel"];
    //性别
    self.QFSex.text = self.QFDataDic[@"gender"];
    self.QFbirthDate.text = self.QFDataDic[@"birth"];
    self.QFemail.text = self.QFDataDic[@"mail"];
    self.QFregion.text =[NSString stringWithFormat:@"%@ %@ %@",self.QFDataDic[@"province"],self.QFDataDic[@"city"],self.QFDataDic[@"county"]];
}


-(void)changeImg {
    NSLog(@"更换头像啊");
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"手机相册", nil];
    [sheet showInView:self.view];
    
    
}


#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self showImagePickerWithCamare:YES];
            break;
        case 1:
            [self multiSelectImagesFromPhotoLibrary];
            break;
    }
}

//相册代理方法
#pragma mark - Control
/**
 *  拍照
 *  相册
 *  @param showCamare
 */
- (void)showImagePickerWithCamare:(BOOL)showCamare
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (showCamare) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    
    if(![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        NSLog(@"不支持拍照");
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

/**
 *  调起可多选图片相册，选择图片
 */
- (void)multiSelectImagesFromPhotoLibrary
{
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = false;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"Selected assets:");
    [self UpdateImgData:[assets lastObject]];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Canceled.");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)UpdateImgData:(PHAsset *)asset {   //转成NSData再获取
     __block  UIImage *image;
    PHImageManager *imageMannager = [PHImageManager defaultManager];
    [imageMannager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        image= [[UIImage alloc]initWithData:imageData];
        [self.iCoView setImage:image];
    }];
    
    [self UpLoadImg:image];
    
}



-(void)UpLoadImg:(UIImage *)newIcon{
    //格式化图片
    NSData *imageData =  UIImageJPEGRepresentation(self.iCoView.image,.8);
    //先把图片上传过去
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval  = 30.0;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
   // NSString *url2 = [NSString stringWithFormat:@"http://www.123qf.cn/app/file/upload.front?userID=%@",app.usrInfoDic[@"userid"]];//
   NSString *url2 = [NSString stringWithFormat:@"http://www.123qf.cn/app/file/upload.front"];//
    ///file/upload.front

    [manager POST:url2 parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
        [formData appendPartWithFileData:imageData name:@"icon.jpg" fileName:@"1.jpg" mimeType:@"image/jpg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"第一次提交数据%@",responseObject);
        NSString *imgName = responseObject[@"data"];
        [self realUpdate:imgName];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络超时，稍后尝试"];
    }];
    //获得图片名称，在把整个字典传过去
}


-(void)realUpdate:(NSString *)NewImgStr {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url =  [NSString stringWithFormat:@"http://www.123qf.cn/app/user/updatePortrait.api?img_name=%@",NewImgStr];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"第二次返回数据:%@",responseObject);
         NSLog(@"DEBUG");
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}



@end
