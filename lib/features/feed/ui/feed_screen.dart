import 'package:dio/dio.dart';
import 'package:farmeasy/features/feed/bloc/feed_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../const.dart';
import 'web_view_container.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  var jsonList;
  @override
  void initState() {
    feedBloc.add(FeedInitialEvent());
    getData();
    super.initState();
  }

  FeedBloc feedBloc = FeedBloc();

  void getData() async {
    feedBloc.add(FeedInitialEvent());
    try {
      var response = await Dio().get(
          'https://newsdata.io/api/1/news?apikey=pub_434851701d6f7376b583e163601a6c27e2890&q=farmer,%20agriculture&country=in');
      if (response.statusCode == 200) {
        setState(() {
          jsonList = response.data['results'] as List;
        });
        feedBloc.add(FeedLoadCompleteEvent());
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: feedBloc,
      listenWhen: (previous, current) => current is FeedActionState,
      buildWhen: (previous, current) => current is! FeedActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case FeedInitial:
            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white,
              ),
              body: Center(
                child: Lottie.asset(
                  "assets/seed.json",
                  fit: BoxFit.cover,
                  backgroundLoading: true,
                  animate: true,
                ),
              ),
            );
          case FeedLoadCompleteState:
            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white,
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  getData();
                },
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: jsonList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WebViewContainer(url: jsonList[index]['link']),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Image.network(
                                  jsonList[index]['image_url'],
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 14),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(jsonList[index]['title']),
                                      Text(
                                        jsonList[index]['pubDate'],
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
