import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

import '../models/promotion.dart';
import '../widgets/error.dart';

class PromotionsPage extends StatefulWidget {
  final MainModel model;
  const PromotionsPage(this.model, {super.key});
  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  @override
  initState() {
    super.initState();
    widget.model.fetchPromotions().then((bool success) {
      if (!success && mounted) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const ShowErrorDialogue();
            });
      }
    });
  }

  late Promotion promotion;


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
                      title: const Text('Confirm Deletion'),
                      content: Text('Are you sure you want to delete ${promotion.name}?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('NO'),
                          onPressed: () {
                            model.reinsertPromotion(
                                promotion, model.promotions.length - index - 1);

                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text('YES'),
                          onPressed: () {
                            Navigator.pop(context);
                            model
                                .deletePromotion(
                                    model.promotions.length - index - 1)
                                .then((bool success) {
                              if (!mounted) return;
                              if (success) {
                              } else {
                                model.reinsertPromotion(promotion,
                                    model.promotions.length - index - 1);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const ShowErrorDialogue();
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
                      title: const Text('Error'),
                      content: const Text('You do not have access to this function'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
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
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Description'),
                            content: Text(model
                                .promotions[model.promotions.length - index - 1]
                                .description),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.info,
                  ),
                ),
              ),
              const Divider(),
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
        builder: (BuildContext context, Widget? child, MainModel model) {
      Widget content = const Center(child: Text('No promotions found'));
      if (model.isLoading) {
        content = const Center(child: CircularProgressIndicator());
      } else if (model.promotions.isNotEmpty) {
        content = listPromotions(model);
      }
      return Scaffold(
          drawer: Drawer(
            child: Column(children: model.listTiles),
          ),
          appBar: AppBar(
            title: const Text('Promotions'),
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
                        title: const Text('Add Promotion'),
                        children: <Widget>[
                          SimpleDialogOption(
                            child: TextField(
                              onChanged: (String value) {
                                name = value;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Name of Promo',
                              ),
                            ),
                          ),
                          SimpleDialogOption(
                            child: TextField(
                              maxLines: 3,
                              onChanged: (String value) {
                                description = value;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Description',
                              ),
                            ),
                          ),
                          SimpleDialogOption(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    if (name != '' &&
                                        description != '') {
                                      model.addPromotion(
                                          name, description);
                                      Navigator.pop(context);
                                    } else {}
                                  },
                                  child: const Text('Confirm'),
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
                        title: const Text('Error'),
                        content:
                            const Text('You do not have access to this function'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      );
                    });
              }
            },
            tooltip: 'Add promo',
            child: const Icon(Icons.add),
          ));
    });
  }
}
