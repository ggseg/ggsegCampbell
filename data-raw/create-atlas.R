library(ggsegExtra)
library(ggseg)
library(ggseg3d)
library(dplyr) # for cleaning the atlas data efficiently
library(tidyr) # for cleaning the atlas data efficiently

# The unique name of the atlas annot, without hemisphere in filename
annot_name <- "campbell"

for(hemi in c("lh", "rh")){
  tmp <- here::here(sprintf("data-raw/Campbell/%s.fsaverage_Campbell", hemi))
  cat(tmp)
  freesurfer::mris_convert_annot(
    infile = file.path(freesurfer::fs_subj_dir(), "fsaverage", "surf", "rh.orig"),
    annot = sprintf("%s.label.gii", tmp),
    ext = ".annot",
    outfile = sprintf("%s.annot", tmp)
  )  
}

# bash
# sudo cp data-raw/Campbell/lh.fsaverage_campbell.annot $FREESURFER_HOME/subjects/fsaverage/label/lh.campbell.annot
# sudo cp data-raw/Campbell/rh.fsaverage_campbell.annot $FREESURFER_HOME/subjects/fsaverage/label/rh.campbell.annot


# You might need to convert the annotation file
# convert atlas to fsaverage5
lapply(c("lh", "rh"),
       function(x){
         mri_surf2surf_rereg(subject = "fsaverage",
                             annot = annot_name,
                             hemi = x,
                             output_dir = here::here("data-raw/fsaverage5/"))
       })


# Make  3d ----
campbell_3d <- make_aparc_2_3datlas(
  annot = annot_name,
  annot_dir = here::here("data-raw/fsaverage5/"),
  output_dir = here::here("data-raw/")
)
ggseg3d(atlas = campbell_3d)

## fix atlas ----
# you might need to do some alteration of the atlas data,
# like cleaning up the region names so they do not contain
# hemisphere information, and any unknown region should be NA
campbell_n <- campbell_3d
campbell_n <- unnest(campbell_n, ggseg_3d)
campbell_n <- mutate(campbell_n,
                    region = ifelse(grepl("Unknown|\\?", region, ignore.case = TRUE), 
                                    NA, region),
                    atlas = "campbell_3d"
)
campbell_3d <- as_ggseg3d_atlas(campbell_n)
ggseg3d(atlas  = campbell_3d)


# Make palette ----
brain_pals <- make_palette_ggseg(campbell_3d)
usethis::use_data(brain_pals, internal = TRUE, overwrite = TRUE)
devtools::load_all(".")


# Make 2d polygon ----
campbell <- make_ggseg3d_2_ggseg(campbell_3d, 
                                 steps = 6:7,
                                 tolerance = .25,
                                 output_dir = here::here("data-raw/"))

plot(campbell)

campbell %>%
  ggseg(atlas = ., show.legend = FALSE,
        colour = "black",
        mapping = aes(fill=region)) +
  scale_fill_brain("campbell", package = "ggsegCampbell", na.value = "black")


usethis::use_data(campbell, campbell_3d,
                  internal = FALSE,
                  overwrite = TRUE,
                  compress="xz")


# make hex ----
atlas <- campbell

p <- ggseg(atlas = atlas,
           hemi = "left",
           view = "lateral",
           show.legend = FALSE,
           colour = "grey30",
           size = .2,
           mapping = aes(fill =  region)) +
  scale_fill_brain2(palette = atlas$palette) +
  theme_void() +
  hexSticker::theme_transparent()

lapply(c("png", "svg"), function(x){
  hexSticker::sticker(p,
                      package = "ggsegCampbell",
                      filename = sprintf("man/figures/logo.%s", x),
                      s_y = 1.2,
                      s_x = 1,
                      s_width = 1.5,
                      s_height = 1.5,
                      p_family = "mono",
                      p_size = 10,
                      p_color = "grey30",
                      p_y = .6,
                      h_fill = "white",
                      h_color = "grey30"
  )
  
})

pkgdown::build_favicons(overwrite = TRUE)
