MicroFossil Segmentation Editor Manual

# Introduction

X-ray micro computer tomography (x-ray µCT) allows the quantification of morphological features of microfossils in an unprecedented level of detail and completeness. This software toolbox is designed to assist researchers in the extraction of morphological data out of the µCT scan data accurately and reproducibly and allows the comprehensive manipulation of microfossil (in particular foraminifera) segmentation data.

# General notes

- The basic shell segmentation cannot be edited with MFSE.
- A label patch consisting of only a few voxels might not be rendered in the normal or smoothed visualization. Change the visualization to voxels to make the label patch visible.
- Label operations are generally irreversible.

# Table of contents

[Toolbar Menu](#-toolbar-menu)

[File](#_file)

[Import](#_import)

[Macros](#_macros)

[Export](#_export)

[Preferences](#_preferences)

[Help](#_help)

[GUI](#_Toc216706868)

[Segmentation project information panel](#_Toc216706869)

[View and select panel](#_Toc216706870)

[Camera controls](#_Toc216706871)

[3D environment visualization panel](#_Toc216706872)

[Basic shell segmentation panel](#_Toc216706873)

[General label operations panel](#_Toc216706874)

[Lumen label operations panel](#_Toc216706875)

[Shell label operations panel](#_Toc216706876)

[Label data panel](#_Toc216706877)

[Hotkeys](#_Toc216706878)

[Project Creation Tool](#_Toc216706879)

[References](#_Toc216706880)

[Glossary](#_Toc216706881)

# Toolbar Menu

## File

#### Open project creation tool

This menu item opens the Project Creation Tool. This tool will allow you to create a segmentation project and MSD file. The usage of the Project Creation Tool is described in the respective chapter of this manual

#### Load project

Loads a previously created or saved segmentation project file (MSD file format).

#### Save project

Saves your current segmentation project file (MSD file format). A dialogue will open and asks for the file name.

#### Revert project

Reverts your current segmentation project to the last saved version.

## Import

#### External ambient occlusion data

Imports ambient occlusion data from an external source (e.g. from AMIRA). This data can then be used in the Delimit in situ operation, saving MFSE from calculation of the ambient occlusion which is currently a very time intensive operation.

## Macros

#### Finalize shell layer

This macro assigns any shell voxels not yet labeled to a set of new labels according to their vicinity to any labeled primary shells.

#### Recalculate all label properties

This macro recalculates all the label properties (Volume, Solidity etc.).

## Export

#### Export RAW

Exports the current project as a RAW binary. The voxel data of all layers is exported, the volume dimensions, voxelsize and data encoding is appended to the project name and suggested in the dialog that opens and asks for the file name.

#### Export GIPL

Exports the current project as a GIPL file. A dialog opens to select the layer to be exported. A text file with the label descriptions is created alongside. This file can be imported into ITK-snap and will not only contain the label names but also the colormap and label visibility of the segmentation project at the time of export. The text file essentially recreates the current view of MFSE in ITK-Snap.

## Preferences

Opens a window where certain processing and display parameters can be altered. The File item in the toolbar menu allows the saving and loading of user specific preferences as well as the setting of default values. Note that any changes need to be applied via the Apply button to take effect.

#### Parallel computing

All options for the use of a parallel pool. Parallel computing is used as standard (if available) for many of the more complex calculations such as the generation of ambient occlusion fields.

#### Lighting

This panel contains all lighting option. After changes have been made all patch will need to be regenerated.

#### Label operation defaults

This panel contains all the options for default parameter values for any kind of label operation.

#### Label table optional properties

This table contains all the available parameters in different units shown in the label data table of the GUI. This list is likely to change with future versions of MFSE.

## Help

#### About

Shows the current version and additional information on MFSE.

#### Show Manual

Opens this Manual.

#### Show Tutorials

Redirects you to the MFSE YouTube channel, where short tutorial videos (e.g. a Step-by-Step guide through the basic segmentation of a supplied example data file) can be found.

# GUI

The GUI is subdivided into several regions and panels, which are described in the following sections.

## Segmentation project information panel

This panel will present the basic segmentation project information, including:

**Name** - Name of the segmentation project

**Voxelsize \[µm\]** - Voxelsize/Resolution of the underlying scan data in µm

**Dimensions \[X Y Z ; vx\]** - X/Y/Z - Dimensions of the underlying scan data in voxels

**Basic shell source** - Source file of the basic shell segmentation

**Primary label source** - Source (file) of the primary label data

**Labels** - shows the number of unique labels in this project

**Active** - shows the number of active labels in this project

**Layers** - shows the number of layers in this project

**Morphounits** - shows the number of morphounits in this project

**Classes** - shows the number of classes in this project

**Groups** - shows the number of groups in this project

**Types** - shows the number of types in this project

**Comment** - allows you to enter any comment, e.g. to memorize the label you are currently working on, notes about the specimen, etc.

## View and select panel

This section covers basic selection and visibility options of the labels, as well as a possibility to display and visually modify the underlying, imported basic shell segmentation.

#### View/Select

This button allows you to toggle between the View and Select tool. The View tool option allows these basic operations: Rotate the view by pressing the Middle Mouse Button and then moving your cursor. The view remains centered on the object. Stop moving by clicking the Left Mouse Button. Zoom in/out with your Mouse Scroll Wheel. The Select tool option allows these basic operations: Select/Deselect certain labels by clicking them with the Left Mouse Button. Holding shift while selecting labels by pointer allows the selection of several labels. Clicking on a selected label will deselect all currently selected labels. Holding shift while clicking on a selected label will only deselect the clicked label and retain the remaining current selection of labels.

#### Label selection

This field shows the label numbers of the currently selected labels.

#### Select visible

Select all visible labels. The visible property can be set in the Label data table.

#### Invert selection

Inverts the selection of all visible labels (i.e. selects all previously non-selected labels and deselects previously selected labels). The visible property can be set in the Label data table.

#### Show all

Shows all labels.

#### Hide all

Hides all labels.

#### Show only selection

Shows only currently selected label(s).

#### Show in vicinity

After selecting a single label this allows you to selectively show only labels that have their centroid located in a defined distance <= X voxels to the selected label. A dialog opens that asks for the distance value to use. This distance value used for selectively showing labels is independently calculated from the Distance entry in Label data table in the Label data panel.

#### Label filter

The following elements allow you to customize which labels are visualized in the _Visualization panel_ through various filter and display options:

#### Show

Shows all labels (i.e. adds labels to the Visualization panel) that match the selected _Label filter_s.

#### Hide

Hides all labels that match the selected Label filter_s_**_._**

#### .. only

Can be used in combination with _Show_ to only display labels matching the _Label filter_s.

#### .. active

Can be used in combination with _Show_ and .. only .. to display active labels matching the _Label filter_s.

#### MU

Morphounit filter parameters - the first dropdown-list to the right allows you to select less than or equal to (&lt;=), greater than or equal to (&gt;=), equal to (==), or not equal to (!=) labels according to the morphounit number in the second dropdown-list to the right.

#### Layer

Layer filter parameters - the first dropdown-list to the right to the right allows you to select less than or equal to (&lt;=), greater than or equal to (&gt;=), equal to (==), or not equal to (!=) labels according to Layer number in the second dropdown-list to the right.

#### Class

Class filter parameters - the first dropdown-list to the right allows you to select equal to (==), or not equal to (!=) labels according to Class type in the second dropdown-list to the right.

#### Group

Group filter parameters - the first dropdown-list allows you to select equal to (==), or not equal to (!=) labels according to Group type in the second dropdown-list to the right.

## Camera controls

In addition to cursor-controlled camera control in the _Visualization panel_, this panel allows you to manually control the camera of the visualization with the following buttons:

**Roll left/right**

**Tilt up/down**

**Tilt left/right**

**Zoom in/out**

Note the camera control buttons move the camera in the relation to the original axes of the data. These axes can be made visible with the _Axes show_ button.

## 3D environment visualization panel

#### Frame Show

Toggles the visibility of the 3D frame.

#### Frame Color

A dialog window will open that allows to choose the color of the background of the 3D frame.

#### Axes Show

Toggles the visibility of the 3D axes.

#### Axes Color

A dialog window will open that allows to choose the color of the 3D axes.

#### Axis labels Show

Toggles the visibility of the 3D axes labels.

#### Grid Show

Toggles the visibility of the 3D grid.

## Basic shell segmentation panel

**Note:** The basic shell segmentation CANNOT be edited in MFSE.

#### Show

Toggles the visibility of the basic shell segmentation patch.

#### Color

A dialog window will open that allows you to choose the color of the basic shell segmentation patch.

#### Opacity

A slider that changes the opacity of the basic shell segmentation patch.

## General label operations panel

The _General label operations_ is the first alternatively active panel: _General_, _Lumen_ and _Shell label operations_. This panel includes all the available operations for the editing process of the labels regardless of class.

#### Combine

Combines the selected labels in a volume constant operation. To execute this operation, a minimum of two labels needs to be selected. These labels have to be connected in an 18-connectivity 3D neighborhood and must exist in the same layer. A dialogue window will ask for the name of the new label.

#### Divide

Splits the selected singular label into a number of desired subvolumes in form of new labels in a volume constant operation. A dialog opens that asks for the number of desired subvolumes. When this label operation is applied, MFSE will automatically append "split patch NX" to the names of the newly generated labels, where X represents a consecutive numbering of the newly generated labels. To execute this operation, one label needs to be selected which consists of only one patch.

#### Singularize

Removes all but the largest patch of non-singular labels. To execute this operation, one or multiple labels need to be selected but each label must consist of multiple patches.  
**WARNING** The removed patches are deleted.

#### Separate patches

Separates patches based on their individual volumes or solidity. A dialog opens that asks for the minimum volume and minimum solidity of patches to separate. These two thresholds will be combined, empty entries will be ignored. Labels below the combined threshold will not be separated. MFSE will automatically append "subpatch NX" to the names of the resulting labels, where X represents a consecutive numbering. To execute this operation, one or multiple labels need to be selected which consist of multiple patches.

#### Transfer

Moves the selected label(s) to a different layer. A dialog opens and asks for the destination layer. Label voxels in the destination layer will be overwritten by the moved labels. To execute this operation, one or multiple labels need to be selected.

**WARNING** Voxels in the target layer are overwritten without checking whether they already belong to another label.

Copy

Copies the selected label(s) to a different layer. A dialog opens and asks for the name of the new label and the destination layer. Label voxels in the destination layer will be overwritten by the moved labels. To execute this operation, one or multiple labels need to be selected.

WARNING Voxels in the target layer are overwritten without checking whether they already belong to another label.

#### Recolor

Recolors the selected label(s) by assigning a random color from the chosen color map in the _Label data_ panel. To execute this operation, one or multiple labels need to be selected.

#### Recenter

This function sets the centroid of your currently selected label as the center for all distance calculations and recalculates the distance property displayed in the Label data table for all labels.

#### Delete

Deletes the selected label permanently from the harboring label field. To execute this operation, one or multiple labels need to be selected. A dialogue window will ask for confirmation.

#### Merge

Merges exactly two selected labels into one. The labels do not need to be connected but must exist in the same layer. Voxels will be added to connect the two selected labels in 18-connectivity 3D neighborhood.

#### Split

Splits the selected label into a number of desired subvolumes in form of new labels in a non-volume constant operation, that is voxels are lost. A dialog opens that asks for the number of desired subvolumes. When this label operation is applied, MFSE will automatically append "split patch NX" to the name of the newly generated labels, where X represents a consecutive numbering. To execute this operation, one label needs to be selected which consists of only one patch.

#### Subtract

Subtracts one label from another to generate a new label. A dialogue window will open that asks for the name of the new label, the destination layer and which of selected the labels are to be used as minuend and subtrahend. To execute this operation, exactly two labels need to be selected.

**WARNING** Voxels in the target layer are overwritten without checking whether they already belong to another label.

#### Intersect

Creates a new label from the overlapping voxels of two selected labels. A dialogue window will open that asks for the name of the new label and the target layer. To execute this operation, two labels need to be selected.

**WARNING** Voxels in the target layer are overwritten without checking whether they already belong to another label.

#### Remove appendages

Removes appendages via an image closing algorithm. A dialog opens that asks for the reduction factor. The volume is expanded and subsequently eroded by a sphere with the radius of the reduction factor. This operation smooths the outline of the volume and removes small appendages. When this label operation is applied, MFSE will create a new label containing the removed volume and automatically name it by the original name followed by "appendage". To execute this operation, one or multiple labels need to be selected.

## Lumen label operations panel

This panel includes all the available operations for the editing process of lumen labels. This panel is only accessible after at least one label is classified as _Lumen_.

#### Delimit in situ

Delimit the extent of the selected label by finding a threshold value in the ambient occlusion data that maximizes the volume to surface ratio, which is roughly equivalent to finding the most compact shape. The voxels of the basic shell segmentation will be considered in the calculation of the ambient occlusion field. If present, the imported ambient occlusion field will be used. A dialog opens that asks you for the name of the new label and the margin width and number of rays to use for the calculation of the ambient occlusion field. A higher number of rays and larger size of the ambient occlusion field will usually yield more aesthetically pleasing results but also require longer computation time. Note that with a too small field size, "shading" elements of the segmentation data might not be included in the calculation. In some cases, it might be necessary to expand the lumen label in question in order to achieve a certain gradient of values in the calculated ambient occlusion for a satisfying delimitation, the expansion factor serves this purpose. If you think that voxels of another lumen label should be included in the delimitation procedure of this particular label, you can enumerate them in the _additional labels to be considered_ field of the dialogue. Finally, you need to specify the target layer for the operation. When this label operation is applied, MFSE will automatically append "externa" to the newly generated label consisting of the voxels not belonging to the most compact shape of the original label. To execute this operation, one label with the _Class_ Lumen needs to be selected. If the operation cannot be completed with the message "No gradient in the ambient occlusion data found" try expanding the label via the expansion factor.

For a more detailed explanation, please have a look into:

PLACEHOLDER Main publication

#### Delimit concave in vivo

This operation works exactly as the _Delimit in situ_ operation but considers only the primary shell up to the morphounit of the selected lumen label, that is treating the data as if the morphounit of the selected lumen is the ultimate morphounit A dialog opens that asks you for a name of the new label, the margin width and number of rays to use for the calculation of the ambient occlusion field, the expansion factor for the volume, the shell and lumen layer to consider, the target layer optionally which morphounits to consider exclusively and which label to add the separated voxels to. To execute this operation, one label needs to be selected with Class set to Lumen; all lumina present in the data set must have a morphounit assigned belonging to a continuous sequence.

For a more detailed explanation, please have a look into:

PLACEHOLDER Main publication

#### Trace chamber wall

This operation traces the primary chamber wall of the selected lumen label(s). It is an operation particular to the shell of foraminifera and generates a new label that represents the primary chamber wall of the selected lumen label. The primary chamber wall is the hypothesized chamber wall in a condition and thickness just after its construction with the influence of any secondary calcification.

A dialog opens that asks you for the name of the new label and the use of face, vertex or a combination of normals. It is generally recommended to employ both but this increases computation time. You can specify whether single voxel gaps in the shell wall detection path (see below) are allowed and the maximum chamber wall width as percentage of the lumen labels first principal axis. You can specify the voxel radius in which to cover the issue of radial divergence, note that this significantly increases computation time but also helps in generating complete shells for small lumina. You can specify what fraction of the standard deviation should be added to the mean when determining the primary chamber wall thickness (see below) and the target layer for the operation. To execute this operation, one or multiple labels with the class _Lumen_ need to be selected. All segmentation labels need to have an assigned MU and Class.

To find this primary chamber wall, an extended normal vector is projected outwards from each vertex and or face of the label patch. The intersection of this vector with the basic shell segmentation is recorded and the patch length inside the shell calculated. In a fully annotated segmentation the path length, which is the local shell thickness, can be determined for exactly the part of the shell that lies between the current lumen label and the lumen label of the following morphounit. We assume that this part of a chamber shell wall was never exposed to secondary calcification and accordingly represents the primary shell wall thickness. The average shell thickness (plus a user-defined fraction of the mean as determined by a curve fit) for this region is then used for the generation of the primary shell label for the lumen label.

For a more detailed explanation, please have a look into:

PLACEHOLDER Main publication

## Shell label operations panel

This panel includes all the available operations for the editing process of shell labels. This panel is only accessible after at least one label is classified as _Shell_.

#### Delimit convex individual

This operation creates a hypothetical chamber lumen label based on the dimensions of the selected primary shell label. The newly generated lumen label is the convex hull of the shell label minus the shell label. Optionally a morphological opening function can be applied to the result. This operation is intended as an alternative to the Delimit in vivo operation measure for the determination of chamber lumen voluminal. A dialog opens that asks you to enter the name of the new label, the reduction element radius used in the morphological opening operation, whether you want to remove the lower growth stage lumina, the lumen layer to consider for the removal of the lower growth stage lumina, and the target layer of the operation. To execute this operation, one label needs to be selected. Each label needs to have an assigned MU and Class set to _Shell_.

For a more detailed explanation, please have a look into:

PLACEHOLDER Main publication

## Label data panel

#### Relabel

This tool will renumber every label in the project according the current order in the Label data table. This also assigns new colors to each label.

#### Recolor

This tool allows you to recolor the entirety of label patches in this project. The adjacent dropdown-list lets you choose a color palette out of the options: Lines, Colorbrewer, Prism, and HSV.

#### Sort

This allows you to perform a customized sorting of the table item according to the sorting parameter (selection box) and sorting order (radio buttons) next to the button.

#### Filter parameter

This allows you to filter the labels by certain parameters. The dropdown-list lets you choose which parameter you want to filter. The following two buttons allow you to enter a minimum and maximum value for your selected parameter. You can apply the filter by clicking the _Filter_\-button. The filter will deactivate all labels not matching the filter criteria.

#### Force visualization

This allows you to force a visualization method from the adjacent dropdown-list with the options of: Voxels, Normal, and Smoothed.

#### Label information table

This table provides you with all the necessary information about the labels.

**Label** - (editable via label operation)  
This column shows the label numbers. These are automatically assigned when your segmentation data file is created.

**Active** - (manually editable)Any label which might not be relevant to your segmentation project's goal can be set to inactive to facilitate the overview of your work. This column shows which labels are currently active/inactive. Status can be changed by ticking the respective checkboxes. Labels set to inactive are also set to not visible. Inactive labels are ignored for all label operations (e.g. delimit).

**Visible** - (manually editable)  
This column sets the visibility status in the visualization for each label. The status can be changed by ticking/unticking the respective checkboxes.

**Layer** - (editable via label operations)  
This column shows the layer in which the label is stored.

**MU** - (manually editable)  
This column shows the morphounit assigned to the label.

**Name** - (manually editable)  
This column allows you to apply an individual description to the label.

**Class** - (list choice)  
The first hierarchical level of label description. Currently four types are distinguished and can be set: Unclassified, Lumen, Shell and Externa.

**Group** - (manually editable)  
The second hierarchical level of label description. The user is free to use any categorization.

**Type** - (manually editable)  
The third hierarchical level of label description. The user is free to use any categorization.

**Visu**(alization) (list choice)  
This dropdown-list allows you to change the visualization of individual labels. There are three options: normal, smoothed and voxels. Please note that the voxelized visualization requires significantly more performance from your PC, so it should be employed sparingly.

**Patches \[N\]**  
This column shows you how many patches (spatially separated subvolumes, 18-connectivity) a certain label consists of.

**Volume \[vx\]**  
This column shows you the volume of each label, which is the actual number of voxels within the label, returned as a scalar.

**Distance \[vx\]**  
This column shows you the distance of each label to one selected label. This selection can be made by using the "Recenter" tool. The distance is measured from each chamber lumen's centroid.

The enumeration up to this point concludes the obligatory selected and shown label properties. Additional properties can be selected via the Preferences toolbar menu item.

**1st / 2nd / 3rd axis \[vx/um/mm\]**  
This property is calculated via the MATLAB _regionprops3_ function. It is the length of the major axes of the ellipsoid that has the same normalized second central moments as the label patch

**Solidity**  
This property is calculated via the MATLAB _regionprops3_ function. It is the proportion of label voxels in the convex hull, returned as a scalar. Computed as Volume/ConvexVolume.

**Extent**  
This property is calculated via the MATLAB regionprops3 function. It is the proportion of label voxels in the bounding box, returned as a scalar. Computed as Volume/(bounding box width × bounding box height × bounding box depth).

# Hotkeys

A short list of hotkeys is available to facilitate and speed up the processing in MFSE.

**Delete** - \[Control\]+q  
Calls the Delete function for selected labels

**Show/Hide selected label(s)** - \[Control\]+s  
Toggles the Visible property state for selected labels.

**View / Select** - \[Control\]+a  
Toggles the View/Select button state

# Project Creation Tool

The Project Creation tool allows you create the projects files required for MFSE. It is organized into three are 3 main panels on the right side.

PREVIEW Segmentation project information panel

This panel displays the basic project information identical as displayed in MFSE. It is completed step by step during the project creation. The only manually editable field in this panel is the _Comment_ field.

Display panel

The dropdown-list allows you to select which data is displayed in the main GUI region.

Project data panel

This panel displays what project data present and allows you to add data and information to the project. Each of the four input requirements is accompanied by a checkbox starting in red. Upon entering information or data the checkbox will either automatically confirm a correct data input and turn green or will need the user's validation before the data is added. The mandatory inputs can be completed in any order but the following order is suggested.

The Mandatory input consist of the four following items:

**Project information** - The project information consists of the three dimensions in voxels and the cubic resolution in micrometer of the dataset. This information can be entered or modified manually via _Enter_ or is extracted automatically from a GIPL file or RAW data file. In case a RAW data file the information is extracted from the file name. Upon entering or loading this data, the according fields in the _PREVIEW Segmentation project panel_ will be filled and the check box next to project information will turn green. A project name will be suggested based on the name of the loaded file.

**Project name** - In this section, you can enter or modify the name of the project.

**Shell segmentation** -The basic and underlying shell segmentation can be loaded from a GIPL or RAW file. In case of a RAW file several dialogues will open and ask for the data format specification such data type and byte order. After loading the shell segmentation data will be visible in the main part of the GUI and become available in the data dropdown-list of the _Display_ panel. You can scroll through the Z-axis of the data via the slider in the center of the GUI or by using the mouse wheel. This data needs to be validated manually, using the _Validate_ button, to proceed with the Project creation. If you find that the shell segmentation is unsatisfactory, please continue processing your shell segmentation in the software of your choice.

**Lumen labels** - Lastly, Lumen labels are required. For this, you can either use a previous output (e.g. from Amira) and input a GIPL or RAW file, if available, or MFSE will be able to create your own chamber segmentation, using a distance map. This data will also be previewed in the left panel and will have to be validated.

The Optional input includes:

Label description (currently unavailable)

This gives you the opportunity to import a pre-made label description (e.g. from an ITK-Snap TXT file).

Lastly, two pushbuttons perform:

**Clear project**

This action will clear all project information and data without asking for confirmation.

**Create project**

When all mandatory project information is correctly entered and validated, you will be able to create your segmentation project MSD file by using this action. A dialogue will open and ask for the file name and location for the project data.

# References

The MFSE project includes functions or source code derived from

Altman, Y (2019) FindJObj V1.53

(<https://undocumentedmatlab.com/articles/findjobj-find-underlying-java-object>)

Kroon, D-J (2007). GIPL Toolbox V1.0

(<https://www.mathworks.com/matlabcentral/fileexchange/16407-gipl-toolbox>), MATLAB Central File Exchange. Retrieved September 26, 2023.

Schalk, S. (2011) Voxel Image

(<https://www.mathworks.com/matlabcentral/fileexchange/30374-voxel-image>), MATLAB Central File Exchange. Retrieved September 26, 2023.

Legland, D. (2025) MatGeom: A toolbox for geometry processing with MATLAB.

SoftwareX, 29, 101984, DOI:10.1016/j.softx.2024.101984b

Muir, D. (2025). PARFOR progress monitor (progress bar) v3

(<https://github.com/DylanMuir/ParforProgMon>), GitHub. Retrieved 24. November 2025.

Hoelzer, S. (2025). Progressbar

(<https://de.mathworks.com/matlabcentral/fileexchange/6922-progressbar>), MATLAB Central File Exchange. Retrieved 24. November 2025.

Koblick, D. (2025) rotVecAroundArbAxis

(<https://de.mathworks.com/matlabcentral/fileexchange/49916-rotvecaroundarbaxis-unitvec2rotate-rotationaxisunitvec-theta>), MATLAB Central File Exchange. Retrieved 9. Dezember 2025.

Axis Maps / Woodruff, A. (2004), colorbrewer

GitHub repository, <https://github.com/axismaps/colorbrewer/?tab=Apache-2.0-1-ov-file>

# Glossary

Voxel - is a three-dimensional equivalent to a pixel. It represents the value for a (in our case always cubic) regularly sized and spaced portion of a data volume. For the purpose of volume segmentation in MFSE each voxel in each layer either belongs to a label (is set) or represents empty space in your volume (is not set).

Layer - is a three-dimensional volume in which the voxels of your segmentation project data exist. A project can contain several layers; currently the maximum number of layers is set to four.

Patch - is a group of voxels that belong to the same label in the same layer and are connected in 18-connectivity. A patch can consist of a single voxel. The user cannot interact with an individual patch.

Label - is a group of voxels that are treated for the purposes of label operations, display, and organization. A label exists in exactly one layer but can consist of several unconnected patches and is the element the user can manipulate directly.

Class - is an obligate Label property. Currently four types of Class are recognized: _Unclassified_ (default), _Lumen_, _Shell_, and _Externa_. The assigned class of label has consequences for the available label operations and its behavior in certain label operations.

Morphounit - are a descriptive property that is to be used for the enumeration of the successive growth stages of a microfossil (i.e. foraminifera). Multiple labels of different classes can belong to one morphounit.

Volume constant label operations - do neither add nor remove set voxels from your segmentation project. They only change the label associations of set voxels.

Lumen (class)- is (in regard to this software) the volume inside of a microfossil shell or subsection (chamber) thereof. The voxels belonging to a label classified as lumen are not permitted to coexist with voxels set in the basic shell segmentation, that is a lumen label cannot ever expand into the shell volume.

Shell (class)- is (in regard to this software) the volume of a microfossil shell or subsection (chamber) thereof. The voxels belonging to a label classified as shell are permitted to coexist with the voxels set in the basic shell segmentation.

Externa (class)- is (in regard to this software) a volume inside or outside of a microfossil shell or subsection (chamber) thereof. The voxels belonging to a label classified as externa are not permitted to coexist with voxel set in the basic shell segmentation. Externa are generated in several label operations and are often designated to be excluded from the final segmentation.
