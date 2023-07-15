FROM dart:3.0.0-290.2.beta-sdk as build

WORKDIR /apis-and-servers
COPY pubspec.* ./
RUN dart pub get
COPY . .
RUN dart pub get --offline
RUN dart compile exe lib/main.dart -o lib/main

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /apis-and-servers/lib/main /apis-and-servers/lib/

EXPOSE 3402
CMD ["/apis-and-servers/lib/main"]
