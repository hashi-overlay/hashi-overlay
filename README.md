# Hashi Overlay

Gentoo overlay for slotted hashicorp tools.

## Layman

To use the overlay with [layman](https://wiki.gentoo.org/wiki/Layman).

Add the [overlay.xml](https://github.com/hashi-overlay/hashi-overlay/blob/master/overlay.xml)
to `/etc/layman/layman.cfg`:

    overlays: http://www.gentoo.org/proj/en/overlays/repositories.xml
              https://raw.githubusercontent.com/hashi-overlay/hashi-overlay/master/overlay.xml

Then use layman commands to add the overlay:

    layman -f # force fetch the new overlays after updating layman.cfg
    layman -a hashi-overlay
