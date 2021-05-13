import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget videoCard(BuildContext context, QueryDocumentSnapshot snap){
  return Card(
    margin: EdgeInsets.all(10),
    elevation: 10,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      height: 120,
      child: Row(
        children: [
          Stack(
            children: [
              Image(
                image: NetworkImage(snap["thumb_url"]),
                width: 120,
                height: 100,
                fit: BoxFit.fitWidth,
                loadingBuilder: (BuildContext context,Widget child, ImageChunkEvent loadingProgress){
                  if(loadingProgress==null) return child;
                  return SizedBox(
                    width: 120,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    ),
                  );
                },
              ),
              Positioned.fill(
                child: Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.play_circle_outline,color: Colors.white,)
                ),
              )
            ],
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width*0.5347,
                      height: MediaQuery.of(context).size.height*0.08135,
                      child: Center(
                        child: Text(snap['title'],
                          //softWrap: false,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800
                            ),
                          ),
                      )
                      ),
                  Text("By : "+snap['uploader'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}