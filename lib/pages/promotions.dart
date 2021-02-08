import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

import '../models/promotion.dart';
import '../widgets/error.dart';

class PromotionsPage extends StatefulWidget {
  final MainModel model;
  PromotionsPage(this.model);
  @override
  _PromotionsPageState createState() => new _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  @override
  initState() {
    widget.model.fetchPromotions().then((bool success) {
      if (!success) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return ShowErrorDialogue();
            });
      }
    });
    super.initState();
  }

  Promotion promotion;


  Widget listPromotions(MainModel model) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        promotion = model.promotions[model.promotions.length - index - 1];
        return Dismissible(
          key: ObjectKey(model.promotions[model.promotions.length - index - 1]),
          onDismissed: (DismissDirection direction) {
            promotion = model.promotions[model.promotions.length - index - 1];
            if (model.user.manager) {
              showDialog(
                barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Deletion'),
                      content: Text('Are you sure you want to delete ' +
                          promotion.name +
                          '?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('NO'),
                          onPressed: () {
                            model.reinsertPromotion(
                                promotion, model.promotions.length - index - 1);

                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text('YES'),
                          onPressed: () {
                            Navigator.pop(context);
                            model
                                .deletePromotion(
                                    model.promotions.length - index - 1)
                                .then((bool success) {
                              if (success) {
                              } else {
                                model.reinsertPromotion(promotion,
                                    model.promotions.length - index - 1);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ShowErrorDialogue();
                                    });
                              }
                            });
                          },
                        )
                      ],
                    );
                  });
            } else {
              model.reinsertPromotion(
                  promotion, model.promotions.length - index - 1);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('You do not have access to this function'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    );
                  });
            }
          },
          background: Container(color: Colors.red),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.star,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(promotion.name),
                //subtitle: Text('${promotion.discount.toString()}%'),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Description'),
                            content: Text(model
                                .promotions[model.promotions.length - index - 1]
                                .description),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          );
                        });
                  },
                  icon: Icon(
                    Icons.info,
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
      itemCount: model.promotions.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text('No promotions found'));
      if (model.isLoading) {
        content = Center(child: CircularProgressIndicator());
      } else if (model.promotions.isNotEmpty) {
        content = listPromotions(model);
      }
      return Scaffold(
          drawer: Drawer(
            child: Column(children: model.listTiles),
          ),
          appBar: AppBar(
            title: Text('Promotions'),
          ),
          body: RefreshIndicator(
              onRefresh: model.fetchPromotions, child: content),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              String name = '';
              String description = '';
              if (model.user.manager) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: Text('Add Promotion'),
                        children: <Widget>[
                          SimpleDialogOption(
                            child: TextField(
                              onChanged: (String value) {
                                name = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Name of Promo',
                              ),
                            ),
                          ),
                          // SimpleDialogOption(
                          //   child: TextField(
                          //     keyboardType: TextInputType.number,
                          //     onChanged: (String value) {
                          //       discount = int.parse(value);
                          //     },
                          //     decoration: InputDecoration(
                          //       labelText: 'Discount Type',
                          //     ),
                          //   ),
                          // ),
                          SimpleDialogOption(
                            child: TextField(
                              maxLines: 3,
                              onChanged: (String value) {
                                description = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Description',
                              ),
                            ),
                          ),
                          SimpleDialogOption(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    if (name != '' &&
                                        description != '') {
                                      model.addPromotion(
                                          name, description);
                                      Navigator.pop(context);
                                    } else {}
                                  },
                                  child: Text('Confirm'),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    });
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content:
                            Text('You do not have access to this function'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('OK'),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      );
                    });
              }
            },
            tooltip: 'Add promo',
            child: Icon(Icons.add),
          ));
    });
  }
}
