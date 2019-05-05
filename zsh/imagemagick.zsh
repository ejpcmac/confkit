########################
# ImageMagic functions #
########################

##
## Specific outputs
##

# The maximum size on Instagram is 1080x1350, so let’s define a function to get
# the best of this format for vertical images.
vinsta() {
    convert $1 \
        -resize x1350 \
        -background white \
        -gravity center \
        -extent 1080x1350 \
        insta.jpg
}
