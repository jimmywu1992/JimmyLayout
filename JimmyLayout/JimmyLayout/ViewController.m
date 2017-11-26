//
//  ViewController.m
//  JimmyLayout
//
//  Created by wjpMac on 2017/11/24.
//  Copyright © 2017年 JiPing Wu. All rights reserved.
//

#import "ViewController.h"
#import "photoCollectionViewCell.h"
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width

#define ChangePageDalay 8
#define Distance 2 //cell之间的缝隙
#define NN 4 //一行最多几个cell

//图片算法
static CGSize CGSizeResizeToHeight(CGSize size, CGFloat height) {
    size.width *= height / size.height;
    size.height = height;
    return size;
}
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic,strong)UICollectionView *colletionView;
@property (nonatomic,copy)NSMutableArray *imgArray;
@property (nonatomic, assign)float ideal_height;//记录高度
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imgArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 20; i ++) {
        [_imgArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i + 1]]];
   
    }
    

    [self creatCollectionView];
}

-(void)creatCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    layout.minimumLineSpacing = 3;
    layout.minimumInteritemSpacing = 3;
    _colletionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _colletionView.backgroundColor = [UIColor blackColor];
    _colletionView.dataSource = self;
    _colletionView.delegate = self;
    
    [self.view addSubview:_colletionView];
    [self.colletionView registerClass:[photoCollectionViewCell class] forCellWithReuseIdentifier:@"picCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _imgArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

        photoCollectionViewCell *cell = (photoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
        cell.image.image = _imgArray[indexPath.row];
    
    
    
    
    
    
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            view.frame = cell.bounds;
        }
    }
    
    
    
    
    return cell;
    
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    int N = (int)_imgArray.count;

    CGRect newFrames[N];

    _ideal_height = MAX(_colletionView.frame.size.height, _colletionView.frame.size.width) / NN;
    float seq[N];

    float total_width = 0;

    for (int i = 0; i < _imgArray.count; i++) {
        UIImage *image = [_imgArray objectAtIndex:i] ;
        CGSize newSize = CGSizeResizeToHeight(image.size, _ideal_height);
        newFrames[i] = (CGRect) {{0, 0}, newSize};
        seq[i] = newSize.width;
        total_width += seq[i];
    }

    int K = (int)roundf(total_width / _colletionView.frame.size.width);

    float M[N][K];
    float D[N][K];

    for (int i = 0 ; i < N; i++)
        for (int j = 0; j < K; j++)
            D[i][j] = 0;

    for (int i = 0; i < K; i++)
        M[0][i] = seq[0];

    for (int i = 0; i < N; i++)
        M[i][0] = seq[i] + (i ? M[i-1][0] : 0);

    float cost;
    for (int i = 1; i < N; i++) {
        for (int j = 1; j < K; j++) {
            M[i][j] = INT_MAX;

            for (int k = 0; k < i; k++) {
                cost = MAX(M[k][j-1], M[i][0]-M[k][0]);
                if (M[i][j] > cost) {
                    M[i][j] = cost;
                    D[i][j] = k;
                }
            }
        }
    }

    /**
     Ranges & Resizes
     */
    int k1 = K-1;
    int n1 = N-1;
    int ranges[N][2];
    while (k1 >= 0) {
        ranges[k1][0] = D[n1][k1]+1;
        ranges[k1][1] = n1;

        n1 = D[n1][k1];
        k1--;
    }
    ranges[0][0] = 0;

    float cellDistance = Distance;
    float heightOffset = cellDistance, widthOffset;
    float frameWidth;
    for (int i = 0; i < K; i++) {
        float rowWidth = 0;
        frameWidth = _colletionView.frame.size.width - ((ranges[i][1] - ranges[i][0]) + 2) * cellDistance;

        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            rowWidth += newFrames[j].size.width;
        }

        float ratio = frameWidth / rowWidth;
        widthOffset = 0;

        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            newFrames[j].size.width *= ratio;
            newFrames[j].size.height *= ratio;
            newFrames[j].origin.x = widthOffset + (j - (ranges[i][0]) + 1) * cellDistance;
            newFrames[j].origin.y = heightOffset;

            widthOffset += newFrames[j].size.width;
        }
        heightOffset += newFrames[ranges[i][0]].size.height + cellDistance;
    }


    CGRect frame = newFrames[indexPath.row];

    
     return CGSizeMake(frame.size.width - 1, frame.size.height - 1);
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
