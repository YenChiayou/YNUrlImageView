# YNUrlImageView
easy use in reusable view 
supprot ios7~ios9

    YNUrlImageView * urlImageView =[[YNUrlImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [urlImageView getItemImage:[NSURL URLWithString:@"url string here"]];

You also can use in collectionView:cellForItemAtIndexPath:
It will adjust queuePriority automatically which imageview need download as soon as possible.
and save image in temporary directory folder.
