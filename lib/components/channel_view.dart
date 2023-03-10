import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:tutopedia/models/channel_model.dart';
import 'package:tutopedia/models/user_model.dart';
import 'package:tutopedia/providers/auth_provider.dart';
import 'package:tutopedia/screens/lecture_screen.dart';
import 'package:tutopedia/screens/signin_screen.dart';

class ChannelView extends StatefulWidget {
  final List<ChannelModel> channelList;
  final String name;
  final String email;
  final String profilePhoto;
  final String authToken;
  final bool shrinkWrap;

  const ChannelView({
    super.key,
    required this.channelList,
    required this.name,
    required this.email,
    required this.profilePhoto,
    required this.authToken,
    required this.shrinkWrap,
  });

  @override
  State<ChannelView> createState() => _ChannelViewState();
}

class _ChannelViewState extends State<ChannelView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return ListView.builder(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.shrinkWrap ? const ScrollPhysics() : null,
      itemCount: widget.channelList.length,
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 5.0,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          onTap: () {
            if (widget.authToken.isNotEmpty) {
              authProvider.user = User(
                name: widget.name,
                email: widget.email,
                profilePhoto: widget.profilePhoto,
                authToken: widget.authToken,
              );
            }

            if (authProvider.user.authToken.isEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SigninScreen(),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LectureScreen(
                    channel: widget.channelList[index],
                  ),
                ),
              );
            }
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.width * 0.28,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 4.0, 8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: Image.network(
                      "https://i.ytimg.com/vi/${widget.channelList[index].link.substring(30, 41)}/maxresdefault.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 8.0, 8.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.channelList[index].title,
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.channelList[index].channelName,
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: Colors.black45,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        RatingBarIndicator(
                          rating: double.parse(widget.channelList[index].rating),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star_rate_rounded,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 12.0,
                          direction: Axis.horizontal,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 12.0,
                              color: Colors.black45,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              int.parse(widget.channelList[index].studentEnrolled) >= 2
                                  ? "${widget.channelList[index].studentEnrolled} students"
                                  : "${widget.channelList[index].studentEnrolled} student",
                              style: const TextStyle(
                                fontSize: 10.0,
                                color: Colors.black45,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
