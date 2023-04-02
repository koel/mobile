import 'package:app/models/models.dart';
import 'package:app/providers/providers.dart';
import 'package:app/ui/placeholders/placeholders.dart';
import 'package:app/ui/screens/info_sheet/info_sheet.dart';
import 'package:app/ui/widgets/album_artist_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistInfoPane extends StatelessWidget {
  final Song song;

  ArtistInfoPane({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        context.read<ArtistProvider>().resolve(song.artistId),
        context.read<MediaInfoProvider>().fetchForArtist(song.artistId),
      ]),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData || snapshot.hasError)
          return const MediaInfoPanePlaceholder();

        var artist = snapshot.requireData[0] as Artist;
        var info = snapshot.requireData[1] as ArtistInfo;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AlbumArtistThumbnail(entity: artist),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      song.artistName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (info.biography.isEmpty)
              const Padding(
                padding: const EdgeInsets.only(top: 16),
                child: const Text(
                  'No artist information available.',
                  style: const TextStyle(color: Colors.white54),
                ),
              )
            else
              InfoHtml(content: info.biography),
          ],
        );
      },
    );
  }
}