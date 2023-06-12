import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/bloc/add_product/add_product_bloc.dart';
import 'package:flutter_ecatalog/bloc/edit_product/edit_product_bloc.dart';
import 'package:flutter_ecatalog/bloc/products/products_bloc.dart';
import 'package:flutter_ecatalog/data/datasources/local_datasource.dart';
import 'package:flutter_ecatalog/data/models/request/product_request_model.dart';
import 'package:flutter_ecatalog/data/models/response/product_response_model.dart';
import 'package:flutter_ecatalog/presentation/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? titleController;
  TextEditingController? priceController;
  TextEditingController? descriptionController;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  List<ProductResponseModel> data = [];
  void setupScrollController(context) {
    scrollController.addListener(() {
      // print(scrollController.position.userScrollDirection);
      print(offset);
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<ProductsBloc>(context)
              .add(GetProductsEvent(limit: limit, offset: offset));
        }
      }
    });
  }

  int offset = 0;
  int limit = 10;
  @override
  void initState() {
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    setupScrollController(context);

    super.initState();
    context
        .read<ProductsBloc>()
        .add(GetProductsEvent(offset: offset, limit: limit));
  }

  @override
  void dispose() {
    super.dispose();

    titleController!.dispose();
    priceController!.dispose();
    descriptionController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () async {
              await LocalDataSource().removeToken();
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const LoginPage();
              }));
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            data = state.data;
            isLoading = true;
          }
          if (state is ProductsLoaded) {
            data = state.data;
            isLoading = false;
            offset = limit;
            limit = limit + 10;
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    // reverse: true,
                    itemBuilder: (context, index) {
                      // final product = state.data.reversed.toList()[index];
                      return Card(
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Text(
                                            data[index].title ?? '-',
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Text(
                                            data[index].description ?? '-',
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            titleController =
                                                TextEditingController(
                                                    text: data[index].title);
                                            descriptionController =
                                                TextEditingController(
                                                    text: data[index]
                                                        .description);
                                            priceController =
                                                TextEditingController(
                                                    text: data[index]
                                                        .price
                                                        .toString());
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0), // Atur radius yang diinginkan
                                                    ),
                                                    title: const Text(
                                                        'Update Product'),
                                                    content: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          TextField(
                                                            decoration:
                                                                const InputDecoration(
                                                                    labelText:
                                                                        'Title'),
                                                            controller:
                                                                titleController,
                                                          ),
                                                          TextField(
                                                            decoration:
                                                                const InputDecoration(
                                                                    labelText:
                                                                        'Price'),
                                                            controller:
                                                                priceController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                          ),
                                                          TextField(
                                                            maxLines: 3,
                                                            decoration:
                                                                const InputDecoration(
                                                                    labelText:
                                                                        'Description'),
                                                            controller:
                                                                descriptionController,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'cancel')),
                                                      BlocConsumer<
                                                              EditProductBloc,
                                                              EditProductState>(
                                                          listener:
                                                              (context, state) {
                                                        if (state
                                                            is EditProductLoaded) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'Update Product Success')));
                                                          context
                                                              .read<
                                                                  ProductsBloc>()
                                                              .add(GetProductsEvent(
                                                                  limit: limit,
                                                                  offset:
                                                                      offset));
                                                          titleController!
                                                              .clear();
                                                          priceController!
                                                              .clear();
                                                          descriptionController!
                                                              .clear();
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                        if (state
                                                            is EditProductError) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      'Edit Product ${state.message}')));
                                                        }
                                                      }, builder:
                                                              (context, state) {
                                                        if (state
                                                            is EditProductLoading) {
                                                          return const ElevatedButton(
                                                              onPressed: null,
                                                              child: SizedBox(
                                                                  width: 25,
                                                                  height: 25,
                                                                  child:
                                                                      CircularProgressIndicator()));
                                                        }
                                                        return ElevatedButton(
                                                            onPressed: () {
                                                              final model =
                                                                  ProductRequestModel(
                                                                title:
                                                                    titleController!
                                                                        .text,
                                                                price: int.parse(
                                                                    priceController!
                                                                        .text),
                                                                description:
                                                                    descriptionController!
                                                                        .text,
                                                              );

                                                              context
                                                                  .read<
                                                                      EditProductBloc>()
                                                                  .add(DoEditProductEvent(
                                                                      model:
                                                                          model,
                                                                      id: data[index]
                                                                              .id ??
                                                                          0));
                                                            },
                                                            child: const Text(
                                                                'update'));
                                                      })
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: const Icon(Icons.edit)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: data.length,
                  ),
                ),
                isLoading ? const CircularProgressIndicator() : const SizedBox()
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController = TextEditingController();
          descriptionController = TextEditingController();
          priceController = TextEditingController();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add Product'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    const SizedBox(
                      width: 8,
                    ),
                    BlocConsumer<AddProductBloc, AddProductState>(
                      listener: (context, state) {
                        if (state is AddProductLoaded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Add Product Success')),
                          );
                          context.read<ProductsBloc>().add(
                              GetProductsEvent(limit: limit, offset: offset));
                          titleController!.clear();
                          priceController!.clear();
                          descriptionController!.clear();
                          Navigator.pop(context);
                        }
                        if (state is AddProductError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Add Product ${state.message}')),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AddProductLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ElevatedButton(
                            onPressed: () {
                              final model = ProductRequestModel(
                                title: titleController!.text,
                                price: int.parse(priceController!.text),
                                description: descriptionController!.text,
                              );

                              context
                                  .read<AddProductBloc>()
                                  .add(DoAddProductEvent(model: model));
                            },
                            child: const Text('Add'));
                      },
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
