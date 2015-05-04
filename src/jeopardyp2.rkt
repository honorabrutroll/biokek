#lang racket
(require picturing-programs)
(define-struct posn (x y) #:prefab)
(require rackunit)
(define-struct model (player scores info t q) #:prefab)
;info : list of topics
(define-struct topic (paragraph questions) #:prefab)
;questions : list of questions
(define-struct question (q answers correct) #:prefab)
;answers : list of answers
(define-struct answer (data loc) #:prefab)

(define FONTCOLOR "black")
(define WINSIZE 500)
(define TEXT/LINE 30)

(define INFO (list (make-topic "Start" (list (make-question "The authors of this project are Nico Murolo, Johnny Chen, and Edward Yang. The bulk of this project was written in Racket and Python, with some shellscript/batch for the build system. The questions are given in this format:" (list (make-answer "Continue" (make-posn 200 100)) ) (make-answer "Continue" (make-posn 200 100)) )))
                                         (make-topic "Topic" (list (make-question "Question?" (list (make-answer "Another Wrong answer" (make-posn 200 100)) (make-answer "Wrong answer" (make-posn 400 100)) (make-answer "Random right answer" (make-posn 200 150)) (make-answer "Terribly close but still wrong answer." (make-posn 400 150)) ) (make-answer "Random right answer" (make-posn 200 150)) )))
                                         (make-topic "Molecules" (list (make-question "Sodium and Chlorine form a type of bond known as an... (hint: selfish)" (list (make-answer "Metallic Bond" (make-posn 200 100)) (make-answer "Hydrogen Bond" (make-posn 400 100)) (make-answer "Ionic Bond" (make-posn 200 150)) (make-answer "Covalent Bond" (make-posn 400 150)) ) (make-answer "Ionic Bond" (make-posn 200 150)) )))
                                         (make-topic "Molecules" (list (make-question "This type of bond allows the bonded atoms to share electron(s)." (list (make-answer "Metallic Bond" (make-posn 200 100)) (make-answer "Ionic Bond" (make-posn 400 100)) (make-answer "Covalent Bond" (make-posn 200 150)) (make-answer "Hydrogen Bond" (make-posn 400 150)) ) (make-answer "Covalent Bond" (make-posn 200 150)) )))
                                         (make-topic "Molecules" (list (make-question "This allows ice to expand rather than contract when frozen." (list (make-answer "Presence of minor impurities in water" (make-posn 200 100)) (make-answer "Hydrogen Bonding" (make-posn 400 100)) (make-answer "Properties of supercooled matter" (make-posn 200 150)) (make-answer "Diffusion" (make-posn 400 150)) ) (make-answer "Hydrogen Bonding" (make-posn 400 100)) )))
                                         (make-topic "Molecules" (list (make-question "The organic molecule that is known to come mainly from cows." (list (make-answer "Methane" (make-posn 200 100)) (make-answer "Hydrogen Sulfide" (make-posn 400 100)) (make-answer "Arsenic" (make-posn 200 150)) (make-answer "CO2" (make-posn 400 150)) ) (make-answer "Methane" (make-posn 200 100)) )))
                                         (make-topic "Molecules" (list (make-question "This geometric shape allows organic molecules such as Benzene to ramin extremely stable." (list (make-answer "Triangular" (make-posn 200 100)) (make-answer "Hexagonal" (make-posn 400 100)) (make-answer "Pentagonal" (make-posn 200 150)) (make-answer "Octoganol" (make-posn 400 150)) ) (make-answer "Hexagonal" (make-posn 400 100)) )))
                                         (make-topic "Molecules" (list (make-question "A gas commonly used for lighter or torch fuel that has a chemical formula of C4H10" (list (make-answer "C4" (make-posn 200 100)) (make-answer "Butane" (make-posn 400 100)) (make-answer "Carbon Dioxide" (make-posn 200 150)) (make-answer "Natural Gas" (make-posn 400 150)) ) (make-answer "Butane" (make-posn 400 100)) )))
                                         (make-topic "Molecules" (list (make-question "The 3 Phosphate groups attached to an adenosine allow this molecule to be an effective energy carrier" (list (make-answer "ATP" (make-posn 200 100)) (make-answer "DNA" (make-posn 400 100)) (make-answer "ATP" (make-posn 200 150)) (make-answer "AMP" (make-posn 400 150)) ) (make-answer "ATP" (make-posn 200 150)) )))
                                         (make-topic "Molecules" (list (make-question "The further removal of a Phosphate Group from ADP forces it to become a very unstable molecule," (list (make-answer "ATP" (make-posn 200 100)) (make-answer "RNA" (make-posn 400 100)) (make-answer "AMP" (make-posn 200 150)) (make-answer "DNA" (make-posn 400 150)) ) (make-answer "AMP" (make-posn 200 150)) )))
                                         (make-topic "Molecules" (list (make-question "The presence of at least one Hydroxyl Group changes a pure Hydrocarbon to a..." (list (make-answer "OC'd hydrocarbon" (make-posn 200 100)) (make-answer "" (make-posn 400 100)) (make-answer "Nutrient" (make-posn 200 150)) (make-answer "Carbohydrate" (make-posn 400 150)) (make-answer "Revitalized Hydrocarbon" (make-posn 200 200)) ) (make-answer "Carbohydrate" (make-posn 400 150)) )))
                                         (make-topic "Molecules" (list (make-question "Fructose, Sucrose, Galactose,and Glucose all make up a group known as..." (list (make-answer "Monosaccharides" (make-posn 200 100)) (make-answer "Alcohols" (make-posn 400 100)) (make-answer "Disaccharides" (make-posn 200 150)) (make-answer "Saccharides" (make-posn 400 150)) ) (make-answer "Disaccharides" (make-posn 200 150)) )))
                                         (make-topic "Molecules" (list (make-question "This group of elements is essential for all life as we know it." (list (make-answer "FeLiNeS" (make-posn 200 100)) (make-answer "SPONCHNK" (make-posn 400 100)) (make-answer "SPUTiNIK" (make-posn 200 150)) (make-answer "FAmOUSKINGe" (make-posn 400 150)) (make-answer "AmErICa" (make-posn 200 200)) (make-answer "SPONCHNaK" (make-posn 400 200)) ) (make-answer "SPONCHNaK" (make-posn 400 200)) )))
                                         (make-topic "Molecules" (list (make-question "This liquid Organic group's properties allow it to dissolve some things that water cannot. An example is Glycerol." (list (make-answer "Fruit juices" (make-posn 200 100)) (make-answer "Alcohols" (make-posn 400 100)) (make-answer "Spongial Fluids" (make-posn 200 150)) (make-answer "Hydroxyls" (make-posn 400 150)) ) (make-answer "Alcohols" (make-posn 400 100)) )))
                                         (make-topic "Molecules" (list (make-question "This macromolecular group includes Steroids and Fatty Acids, and allows for basic cell membranes." (list (make-answer "Plastics" (make-posn 200 100)) (make-answer "Lipids" (make-posn 400 100)) (make-answer "Proteins" (make-posn 200 150)) (make-answer "Gases" (make-posn 400 150)) ) (make-answer "Lipids" (make-posn 400 100)) )))
                                         (make-topic "Molecules" (list (make-question "These are the monomers of proteins." (list (make-answer "Lipids" (make-posn 200 100)) (make-answer "Carbohydrates" (make-posn 400 100)) (make-answer "Amino Acids" (make-posn 200 150)) (make-answer "Saccharides" (make-posn 400 150)) ) (make-answer "Amino Acids" (make-posn 200 150)) )))
                                         (make-topic "Molecules" (list (make-question "Nutrients can be nonessential." (list (make-answer "No" (make-posn 200 100)) (make-answer "Yes" (make-posn 400 100)) ) (make-answer "Yes" (make-posn 400 100)) )))
                                         (make-topic "Cells (General + DNA)" (list (make-question "What is the theory which describes cytology?" (list (make-answer "Membraneal Seperation Theory" (make-posn 200 100)) (make-answer "Bascterial Theory" (make-posn 400 100)) (make-answer "Cell Theory" (make-posn 200 150)) (make-answer "String Theory" (make-posn 400 150)) ) (make-answer "Cell Theory" (make-posn 200 150)) )))
                                         (make-topic "Cells (General + DNA)" (list (make-question "DNA is formed through the process of ____." (list (make-answer "mRNA Translation" (make-posn 200 100)) (make-answer "Transcription" (make-posn 400 100)) (make-answer "DNA Rebonding" (make-posn 200 150)) (make-answer "DNA Synthesis" (make-posn 400 150)) ) (make-answer "DNA Synthesis" (make-posn 400 150)) )))
                                         (make-topic "Cells (General + DNA)" (list (make-question "DNA, mRNA, and tRNA go through or are formed by translation and transcription, which essentially trnaslates and copies blocks of information called codons until a stopc codon is found." (list (make-answer "Yes" (make-posn 200 100)) (make-answer "No" (make-posn 400 100)) ) (make-answer "Yes" (make-posn 200 100)) )))
                                         (make-topic "Cells (General + DNA)" (list (make-question "These two sugars help create the basic structure of DNA and RNA." (list (make-answer "Deoxyribose and Ribose" (make-posn 200 100)) (make-answer "Sucrose and Fructose" (make-posn 400 100)) (make-answer "Sucrose and Galactose" (make-posn 200 150)) (make-answer "Fructose and Galactose" (make-posn 400 150)) ) (make-answer "Deoxyribose and Ribose" (make-posn 200 100)) )))
                                         (make-topic "Cells (General + DNA)" (list (make-question "Reproduction is one of the many processes which differentiate..." (list (make-answer "Prokaryotes and Eukaryotes" (make-posn 200 100)) (make-answer "mRNA and tRNA" (make-posn 400 100)) (make-answer "Cells and Organelles" (make-posn 200 150)) (make-answer "DNA and RNA" (make-posn 400 150)) ) (make-answer "Prokaryotes and Eukaryotes" (make-posn 200 100)) )))
                                         (make-topic "Cell Processes" (list (make-question "Chloroplast is a structure containing chlorophyll (a special pigment). What makes chlorophyll so special?" (list (make-answer "Chlorophyll can change color depending on the season" (make-posn 200 100)) (make-answer "Chlorophyll fulfills all the roles of that cells would have otherwise done." (make-posn 400 100)) (make-answer "Chlorophyll can absorb light to transform it into chemical energy." (make-posn 200 150)) (make-answer "Chlorophyll is the center of cell synthesis in a plant" (make-posn 400 150)) ) (make-answer "Chlorophyll can absorb light to transform it into chemical energy." (make-posn 200 150)) )))
                                         (make-topic "Cell Processes" (list (make-question "Which of these is the name of the entire process in which plants transform light energy (movement of photons) to chemical energy (energy stored in atomic bonds)?" (list (make-answer "Light Absorption" (make-posn 200 100)) (make-answer "Kreb Cycle" (make-posn 400 100)) (make-answer "Photosynthesis" (make-posn 200 150)) (make-answer "Calvin Cycle" (make-posn 400 150)) ) (make-answer "Photosynthesis" (make-posn 200 150)) )))
                                         (make-topic "Cell Processes" (list (make-question "In which of these processes is the ETC directly involved?" (list (make-answer "Light Reaction" (make-posn 200 100)) (make-answer "Glycolysis" (make-posn 400 100)) (make-answer "Dark Reaction" (make-posn 200 150)) (make-answer "Kreb Cycle" (make-posn 400 150)) ) (make-answer "Light Reaction" (make-posn 200 100)) )))
                                         (make-topic "Cell Processes" (list (make-question "In which photosystem is light absorbed in photosynthesis?" (list (make-answer "Photosystems I and II" (make-posn 200 100)) (make-answer "Photosystem II" (make-posn 400 100)) (make-answer "Photosystem I" (make-posn 200 150)) (make-answer "Photosystem III" (make-posn 400 150)) ) (make-answer "Photosystems I and II" (make-posn 200 100)) )))
                                         (make-topic "Cell Processes" (list (make-question "Glycolysis is a process which converts..." (list (make-answer "glucose to pyruvate" (make-posn 200 100)) (make-answer "maltose to glucose" (make-posn 400 100)) (make-answer "glucose to maltose" (make-posn 200 150)) (make-answer "pyruvate to glucose" (make-posn 400 150)) ) (make-answer "glucose to pyruvate" (make-posn 200 100)) )))
                                         (make-topic "Cell Processes" (list (make-question "In which reaction (also known as a dark reaction) do plants create sugar?" (list (make-answer "Citric Acid Cycle" (make-posn 200 100)) (make-answer "Energy Transfer" (make-posn 400 100)) (make-answer "Calvin Cycle" (make-posn 200 150)) (make-answer "Glycolysis" (make-posn 400 150)) ) (make-answer "Calvin Cycle" (make-posn 200 150)) )))
                                         (make-topic "Cell Processes" (list (make-question "In the gas exchange, which two gases are typically involved?" (list (make-answer "Nitrogen and Hydrogen" (make-posn 200 100)) (make-answer "Oxygen and Nitrogen" (make-posn 400 100)) (make-answer "CO2 and Hydrogen" (make-posn 200 150)) (make-answer "Oxygen and CO2" (make-posn 400 150)) ) (make-answer "Oxygen and CO2" (make-posn 400 150)) )))
                                         (make-topic "Cell Processes" (list (make-question "Which molecule is primarily used in cellular energy transfer?" (list (make-answer "AMP" (make-posn 200 100)) (make-answer "Phosphates in general" (make-posn 400 100)) (make-answer "ATP" (make-posn 200 150)) (make-answer "ADP" (make-posn 400 150)) ) (make-answer "ATP" (make-posn 200 150)) )))
                                         (make-topic "Cell Processes" (list (make-question "Which type of molecule is NOT used in protein synthesis?" (list (make-answer "RNA" (make-posn 200 100)) (make-answer "Fatty Acids" (make-posn 400 100)) (make-answer "Amino Acids" (make-posn 200 150)) (make-answer "DNA" (make-posn 400 150)) ) (make-answer "Fatty Acids" (make-posn 400 100)) )))
                                         (make-topic "Cell Processes" (list (make-question "Glucose is broken down in..." (list (make-answer "Dehydrolysis" (make-posn 200 100)) (make-answer "Hydrolysis" (make-posn 400 100)) (make-answer "Glucose Desynthesis" (make-posn 200 150)) (make-answer "the Krebs Cycle" (make-posn 400 150)) ) (make-answer "the Krebs Cycle" (make-posn 400 150)) )))
                                         (make-topic "Water" (list (make-question "In diffusion across a membrane, molecules move from a" (list (make-answer "lighter place to a darker place" (make-posn 200 100)) (make-answer "darker place to a ligher place" (make-posn 400 100)) (make-answer "higher concentration to a lower concentration" (make-posn 200 150)) (make-answer "lower concentration to a higher concentration" (make-posn 400 150)) ) (make-answer "higher concentration to a lower concentration" (make-posn 200 150)) )))
                                         (make-topic "Water" (list (make-question "The indicator bromothymol blue is colorless when..." (list (make-answer "The pH is close to neutral" (make-posn 200 100)) (make-answer "bromothymol blue does not turn colorless" (make-posn 400 100)) (make-answer "The pH is more acidic" (make-posn 200 150)) (make-answer "The pH is more basic" (make-posn 400 150)) ) (make-answer "The pH is close to neutral" (make-posn 200 100)) )))
                                         (make-topic "Water" (list (make-question "The difference between pOH and pH is that..." (list (make-answer "pOH measures hydroxyl group concentration while pH measures hydrogen concentrations" (make-posn 200 100)) (make-answer "There is an extra O in the name" (make-posn 400 100)) (make-answer "All of the above" (make-posn 200 150)) (make-answer "Higher numbers are acidic in pOH" (make-posn 400 150)) ) (make-answer "All of the above" (make-posn 200 150)) )))
                                         (make-topic "Water" (list (make-question "The process of linking molecule monomers is..." (list (make-answer "the force" (make-posn 200 100)) (make-answer "dehydrolysis (removal of 2 hydrogens and an oxygen)" (make-posn 400 100)) (make-answer "hydrolysis (addition of 2 hydrogens and an oxygen)" (make-posn 200 150)) (make-answer "a series of hydrolysis and dehydrolysis" (make-posn 400 150)) ) (make-answer "dehydrolysis (removal of 2 hydrogens and an oxygen)" (make-posn 400 100)) )))
                                         (make-topic "Water" (list (make-question "Permeability is a quality of a material that measures how much liquid or gas can pass through the material. Some membranes are sem" (list (make-answer "facilitated diffusion" (make-posn 200 100)) (make-answer "acidity" (make-posn 400 100)) (make-answer "the polarity of water" (make-posn 200 150)) (make-answer "ermeable, or only allow some things in. They do this through..." (make-posn 400 150)) (make-answer "alkalinity" (make-posn 200 200)) ) (make-answer "ermeable, or only allow some things in. They do this through..." (make-posn 400 150)) )))
                                         (make-topic "Organelles" (list (make-question "In a cell, your RNA is stored in..." (list (make-answer "the cytoplasm" (make-posn 200 100)) (make-answer "the ribosomes" (make-posn 400 100)) (make-answer "the vacuoles" (make-posn 200 150)) (make-answer "the nucleolus" (make-posn 400 150)) ) (make-answer "the nucleolus" (make-posn 400 150)) )))
                                         (make-topic "Organelles" (list (make-question "What is the nucleus protected by?" (list (make-answer "The nuclear membrane" (make-posn 200 100)) (make-answer "The cell wall" (make-posn 400 100)) (make-answer "The cytoplasm" (make-posn 200 150)) (make-answer "The nucleolus" (make-posn 400 150)) ) (make-answer "The nuclear membrane" (make-posn 200 100)) )))
                                         (make-topic "Organelles" (list (make-question "The rough endoplasmic reticulum contains ribosomes, which are part of creating which macromolecule?" (list (make-answer "Proteins" (make-posn 200 100)) (make-answer "DNA" (make-posn 400 100)) (make-answer "Lipids" (make-posn 200 150)) (make-answer "Carbohydrates" (make-posn 400 150)) ) (make-answer "Proteins" (make-posn 200 100)) )))
                                         (make-topic "Organelles" (list (make-question "On the other hand, the smooth endoplasmic reticulum creates which macromolecule?" (list (make-answer "Carbohydrates" (make-posn 200 100)) (make-answer "Proteins" (make-posn 400 100)) (make-answer "DNA" (make-posn 200 150)) (make-answer "Lipids" (make-posn 400 150)) ) (make-answer "Lipids" (make-posn 400 150)) )))
                                         (make-topic "Organelles" (list (make-question "The job of a vacuole in a cell is to..." (list (make-answer "store molecules" (make-posn 200 100)) (make-answer "create vitamins" (make-posn 400 100)) (make-answer "release molecules" (make-posn 200 150)) (make-answer "fill up space" (make-posn 400 150)) ) (make-answer "store molecules" (make-posn 200 100)) )))
                                         (make-topic "Organelles" (list (make-question "What is the area in a cell not taken up by organelles called?" (list (make-answer "The gaseous area" (make-posn 200 100)) (make-answer "The cytoplasm" (make-posn 400 100)) (make-answer "There is no name" (make-posn 200 150)) (make-answer "The cell's plasma" (make-posn 400 150)) ) (make-answer "The cytoplasm" (make-posn 400 100)) )))
                                         (make-topic "Organelles" (list (make-question "What job(s) do lysosomes have in a cell?" (list (make-answer "Breakdown of food" (make-posn 200 100)) (make-answer "All of the above" (make-posn 400 100)) (make-answer "Discarding unneeded organelles" (make-posn 200 150)) (make-answer "Disposal of waste" (make-posn 400 150)) ) (make-answer "All of the above" (make-posn 400 100)) )))
                                         (make-topic "Organelles" (list (make-question "Which organelle in a cell creates the most ATP?" (list (make-answer "The smooth endoplasmic reticulum" (make-posn 200 100)) (make-answer "The mitochondria" (make-posn 400 100)) (make-answer "None of these" (make-posn 200 150)) (make-answer "The rough endoplasmic reticulum" (make-posn 400 150)) ) (make-answer "The mitochondria" (make-posn 400 100)) )))
                                         (make-topic "Organelles" (list (make-question "What protects a plant cell?" (list (make-answer "The cell wall" (make-posn 200 100)) (make-answer "A combination of the cell membrane and cell wall" (make-posn 400 100)) (make-answer "None of the above" (make-posn 200 150)) (make-answer "The cell membrane" (make-posn 400 150)) ) (make-answer "A combination of the cell membrane and cell wall" (make-posn 400 100)) )))
                                         (make-topic "Organelles" (list (make-question "An enzyme is a protein which makes certain processes happen faster, which is also the job of a chemical catalyst, something that helps reactions happen." (list (make-answer "Cool " (make-posn 200 100)) ) (make-answer "Cool " (make-posn 200 100)) )))
                                         (make-topic "Scientific inquiry is the wanting of knowledge" (list (make-question "In an experiment, the ___ variable is the variable that does not change, and the ___ variable is the one that changes the ___ variable" (list (make-answer "standardized, independent, dependent" (make-posn 200 100)) (make-answer "dependent, independent, standardized" (make-posn 400 100)) (make-answer "standardized, dependent, independent" (make-posn 200 150)) (make-answer "independent, dependent, standardized" (make-posn 400 150)) ) (make-answer "standardized, independent, dependent" (make-posn 200 100)) )))
                                         (make-topic "Organisms" (list (make-question "Organisms that can sustain their own energy are called..." (list (make-answer "heterotrophs" (make-posn 200 100)) (make-answer "autotrophs" (make-posn 400 100)) ) (make-answer "autotrophs" (make-posn 400 100)) )))
                                         (make-topic "Organisms" (list (make-question "An organism, by definition, is..." (list (make-answer "biotic" (make-posn 200 100)) (make-answer "abiotic" (make-posn 400 100)) ) (make-answer "biotic" (make-posn 200 100)) )))
                                         (make-topic "Organisms" (list (make-question "Which one of these is a part of the qualifications of being a living being?" (list (make-answer "being able to breathe air" (make-posn 200 100)) (make-answer "Responding to stimuli" (make-posn 400 100)) (make-answer "having feelings" (make-posn 200 150)) (make-answer "Being able to move around on your own" (make-posn 400 150)) ) (make-answer "Responding to stimuli" (make-posn 400 100)) )))
                                         (make-topic "Microscope" (list (make-question "_____ Is the main difference between a High Power Objective Lens and a Low Power Objective Lens, or a Simple Microscope and Compound Microscope." (list (make-answer "Power of Magnification" (make-posn 200 100)) (make-answer "Eyepiece Width" (make-posn 400 100)) (make-answer "Slide Count" (make-posn 200 150)) (make-answer "Stage Clips" (make-posn 400 150)) ) (make-answer "Power of Magnification" (make-posn 200 100)) )))
                                         (make-topic "Microscope" (list (make-question "Some basic parts of this are the Nose Piece, Eye Piece, Stage, Stage Clips, and Lenses." (list (make-answer "Extruder" (make-posn 200 100)) (make-answer "Microscope" (make-posn 400 100)) (make-answer "Scanning Electron Microscope" (make-posn 200 150)) (make-answer "Telescope" (make-posn 400 150)) ) (make-answer "Microscope" (make-posn 400 100)) )))
                                         (make-topic "Microscope" (list (make-question "The difference between a Dry Mount and a Wet Mount is..." (list (make-answer "The surrounding air humidity." (make-posn 200 100)) (make-answer "Wet or Dry Slide Samples" (make-posn 400 100)) (make-answer "The presence of water on the slide." (make-posn 200 150)) (make-answer "Wet or Dry Mcroscope Lenses" (make-posn 400 150)) ) (make-answer "The presence of water on the slide." (make-posn 200 150)) )))
                                         (make-topic "Microscope" (list (make-question "This type of slide has a slight dip in the middle over which a cover slide can be placed." (list (make-answer "Rcok Slide" (make-posn 200 100)) (make-answer "Under Slide" (make-posn 400 100)) (make-answer "Depression Slide" (make-posn 200 150)) (make-answer "Holding Slide" (make-posn 400 150)) ) (make-answer "Depression Slide" (make-posn 200 150)) )))
                                         (make-topic "Energy + Broad reactions" (list (make-question "What type of bonds are broken in combustion?" (list (make-answer "Carbon/Oxygen" (make-posn 200 100)) (make-answer "Carbon/Nitrogen" (make-posn 400 100)) (make-answer "Carbon/Hydrogen" (make-posn 200 150)) (make-answer "Carbon/Carbon" (make-posn 400 150)) ) (make-answer "Carbon/Hydrogen" (make-posn 200 150)) )))
                                         (make-topic "Energy + Broad reactions" (list (make-question "Kinetic energy is the energy of movement. Which of the following is a type of kinetic energy?" (list (make-answer "Gravitational energy" (make-posn 200 100)) (make-answer "Heat energy" (make-posn 400 100)) (make-answer "Potential energy" (make-posn 200 150)) (make-answer "Chemical energy" (make-posn 400 150)) ) (make-answer "Heat energy" (make-posn 400 100)) )))
                                         (make-topic "Energy + Broad reactions" (list (make-question "Heat energy is the movement of what?" (list (make-answer "All of the above" (make-posn 200 100)) (make-answer "Molecules" (make-posn 400 100)) (make-answer "Photons" (make-posn 200 150)) (make-answer "Atoms" (make-posn 400 150)) ) (make-answer "All of the above" (make-posn 200 100)) )))
                                         (make-topic "Energy + Broad reactions" (list (make-question "Which type of energy is not potential energy?" (list (make-answer "Nuclear energy" (make-posn 200 100)) (make-answer "Light energy" (make-posn 400 100)) (make-answer "Mechanical energy" (make-posn 200 150)) (make-answer "Chemical energy" (make-posn 400 150)) ) (make-answer "Light energy" (make-posn 400 100)) )))
                                         (make-topic "Energy + Broad reactions" (list (make-question "What is the difference between product and yield?" (list (make-answer "The product is how much is produced, the yield is what is produced" (make-posn 200 100)) (make-answer "The product is what is produced, the yield is the amount produced." (make-posn 400 100)) (make-answer "The two are synonyms and interchangeable " (make-posn 200 150)) ) (make-answer "The product is what is produced, the yield is the amount produced." (make-posn 400 100)) )))
                                         (make-topic "Energy + Broad reactions" (list (make-question "What is the correct name for the nonproduct parts of a reaction?" (list (make-answer "Ingredients" (make-posn 200 100)) (make-answer "Reactants" (make-posn 400 100)) (make-answer "Catalysts" (make-posn 200 150)) (make-answer "Chemicals" (make-posn 400 150)) ) (make-answer "Reactants" (make-posn 400 100)) )))
                                         (make-topic "Energy + Broad reactions" (list (make-question "A chemical equation has to be balanced (same atoms on both sides, reactants and products.)" (list (make-answer "False" (make-posn 200 100)) (make-answer "True" (make-posn 400 100)) ) (make-answer "False" (make-posn 200 100)) )))
                                         (make-topic "Energy + Broad reactions" (list (make-question "A chemical equation has to be balanced to work" (list (make-answer "True" (make-posn 200 100)) (make-answer "False" (make-posn 400 100)) ) (make-answer "True" (make-posn 200 100)) )))
                                         ))
(define (game-over m p)
  (make-model (model-player m)
              (if (equal? 1 p)
                  (make-posn (+ 20 (posn-x (model-scores m))) (posn-y (model-scores m)))
                  (make-posn (posn-x (model-scores m)) (+ 20 (posn-y (model-scores m)))))
              (list (make-topic "" (list (make-question "Game over!"
                                                                                          `()
                                                                                          (make-answer "kek" (make-posn 50 100)))))) 0 0))

(define (start-game player)
  (make-model player (make-posn 0 0) INFO 0 0))

(define (one-word l)
  (cond [(empty? l) `()]
        [(not (equal? (first l) #\space)) (cons (first l) (one-word (rest l)))]
        [else (list)]))
(equal? (one-word (list #\h #\i #\space #\k)) (list #\h #\i))

(define (rest-word l)
  (cond [(empty? l) `()]
        [(equal? (first l) #\space) (rest l)]
        [else (rest-word (rest l))]))
(equal? (rest-word (list #\space #\k #\i)) (list #\k #\i))

(define (font-helper str cur)
  (cond [(equal? str "") `()]
        [(<= (+ 1 cur (length (one-word (string->list str)))) TEXT/LINE) (append (one-word (string->list str))
                                                                                 (list #\space)
                                                                               (font-helper (list->string (rest-word (string->list str)))
                                                                                            (+ cur (length (one-word (string->list str)))))
                                                                               )]
        [else `()]))
(equal? (list->string (font-helper "fkekl fkekl fkekl hi" 0)) "fkekl fkekl fkekl hi ")

(define (rest-font-helper str cur)
  (cond [(equal? str "") `()]
        [(>= (+ 1 cur (length (one-word (string->list str)))) TEXT/LINE) (string->list str)]
        [else (rest-font-helper (list->string (rest-word (string->list str))) (+ cur (length (one-word (string->list str)))))]))
(equal? (list->string (rest-font-helper "fkekl fkekl fkekl hi fkekl lol p kfd" 0)) "kfd")

(define (finish-fonts str)
  (cond [(equal? str "") (square 0 "solid" "black")]
        [else (above/align "left" (text (list->string (font-helper str 0)) 12 FONTCOLOR)
                     (finish-fonts (list->string (rest-font-helper str 0))))]))

(define (font str)
  (finish-fonts str))

(define (send i)
  (make-package i (if (equal? (model-player i) 1)
                      (make-model 2 (model-scores i) (model-info i) (model-t i) (model-q i))
                      (make-model 1 (model-scores i) (model-info i) (model-t i) (model-q i)))))

;string or img -> int
(define (len ans)
  (cond [(string? ans) (image-width (font ans))]
        [else (image-width ans)]))
(define (height ans)
  (cond [(string? ans) (image-height (font ans))]
        [else (image-height ans)]))

;posn mouse, answer a -> bool
(define (touching? mouse a)
  (if (and (and (<= (posn-x mouse) (+ (posn-x (answer-loc a)) (/ (len (answer-data a)) 2)))
                (>= (posn-x mouse) (- (posn-x (answer-loc a)) (/ (len (answer-data a)) 2))))
           (and (<= (posn-y mouse) (+ (posn-y (answer-loc a)) (/ (height (answer-data a)) 2)))
                (>= (posn-y mouse) (- (posn-y (answer-loc a)) (/ (height (answer-data a)) 2)))))
      true
      false))

;posn i, list of answers l -> false or answer
(define (find-clicked i l)
  (cond [(empty? l) false]
        [(touching? i (first l)) (first l)]
        [else (find-clicked i (rest l))]))

;model m -> topic
(define (current-topic m)
  (list-ref (model-info m) (model-t m)))

;model m -> question
(define (current-question m)
  (list-ref (topic-questions (current-topic m)) (model-q m)))

;info i, topic t -> info
(define (nullify-paragraph i t)
 (cond [(empty? i) (list)]
       [(equal? (first i) t) (cons (make-topic "" (topic-questions (first i))) (nullify-paragraph (rest i) t))]
       [else (cons (first i) (nullify-paragraph (rest i) t))]))

;model m -> bool
(define (next-question-new-topic? m)
  (if (equal? (length (topic-questions (current-topic m))) (+ 1 (model-q m)))
      true
      false))

;int p, topic t, question q, model m -> model
(define (award-point p t q m)
  (if (equal? p 1)
      (if (= (+ (model-t m) 1) (length (model-info m)))
          (send (game-over m p))
      (send (make-model p
                        (make-posn (+ 20 (posn-x (model-scores m))) (posn-y (model-scores m)))
                        (model-info m)
                        (if (next-question-new-topic? m)
                            (+ 1 (model-t m))
                            (model-t m))
                        (if (next-question-new-topic? m)
                            0
                            (+ (model-q m) 1)))))
      (if (= (+ (model-t m) 1) (length (model-info m)))
          (send (game-over m p))
          (send (make-model p
                        (make-posn (posn-x (model-scores m)) (+ 20 (posn-y (model-scores m))))
                        (model-info m)
                        (if (next-question-new-topic? m)
                            (+ 1 (model-t m))
                            (model-t m))
                        (if (next-question-new-topic? m)
                            0
                            (+ (model-q m) 1)))))))

(define (replace item newitem lst)
  (local [(define (repl x)
            (cond [(equal? item x) newitem]
                  [else x]))]
    (map repl lst)))

(define (remansw ans q top info)
  (replace top (make-topic (topic-paragraph top) 
                           (replace q (make-question (question-q q) 
                                                     (remove ans (question-answers q))
                                                     (question-correct q)) 
                                    (topic-questions top))) 
           info))

(define (remove-point p t q m a)
  (if (equal? p 1)
      (send (make-model p
                        (make-posn (- (posn-x (model-scores m)) 5) (posn-y (model-scores m)))
                        (remansw a (current-question m) (current-topic m) (model-info m))
                        (model-t m)
                        (model-q m)))
      (send (make-model p
                        (make-posn (posn-x (model-scores m)) (- (posn-y (model-scores m)) 5))
                        (remansw a (current-question m) (current-topic m) (model-info m))
                        (model-t m)
                        (model-q m)))))

;bool r, int p, answer a, model m -> model
(define (credit-answer r p a m)
  (if r
      (if (equal? p 1)
          (award-point 1 (current-topic m) (current-question m) m)
          (award-point 2 (current-topic m) (current-question m) m))
      (if (equal? p 1)
          (remove-point 1 (current-topic m) (current-question m) m a)
          (remove-point 2 (current-topic m) (current-question m) m a))))

;answer a, question q, int p, model m -> model
(define (check-answer a q p m)
  (cond [(equal? a (question-correct q)) (credit-answer true p a m)]
        [else (credit-answer false p a m)]))

(define (mouse-handler old x y event)
  (cond [(and (equal? event "button-down") (not (equal? "" (topic-paragraph (current-topic old)))))
         (send (make-model (model-player old)
                           (model-scores old)
                           (nullify-paragraph (model-info old) (current-topic old))
                           (model-t old)
                           (model-q old)))]
         [(equal? event "button-down") (if (not (equal?
                                                (find-clicked (make-posn x y) (question-answers (current-question old)))
                                               false))
                                          (check-answer (find-clicked (make-posn x y) (question-answers (current-question old)))
                                                        (current-question old)
                                                        (model-player old)
                                                        old)
                                          (send old))]
        [else (send old)]))

(define (receive-func model msg)
  msg)

(define (draw-scores m)
  (place-image (above (text (string-append "Player 1: " (number->string (posn-x (model-scores m)))) 12 "black")
                      (text (string-append "Player 2: " (number->string (posn-y (model-scores m)))) 12 "black"))
               (- WINSIZE (/ (image-width (above (text (string-append "Player 1: " (number->string (posn-x (model-scores m)))) 12 "black")
                                              (text (string-append "Player 2: " (number->string (posn-y (model-scores m)))) 12 "black"))) 2))
               (/ (image-height (above (text (string-append "Player 1: " (number->string (posn-x (model-scores m)))) 12 "black")
                                    (text (string-append "Player 2: " (number->string (posn-y (model-scores m)))) 12 "black"))) 2)
               (square WINSIZE "solid" (make-color 0 0 0 0))))

(define (draw-question m)
  (place-image (font (question-q (current-question m)))
               (/ (image-width (font (question-q (current-question m)))) 2)
               (/ (image-height (font (question-q (current-question m)))) 2)
               (square WINSIZE "solid" (make-color 0 0 0 0))))

(define (draw-answers l)
  (cond [(empty? l) (square WINSIZE "solid" (make-color 0 0 0 0))]
        [else (place-image (overlay (if (string? (answer-data (first l)))
                                        (font (answer-data (first l)))
                                        (answer-data (first l)))
                                    (rectangle (+ 2 (image-width (if (string? (answer-data (first l)))
                                                                     (font (answer-data (first l)))
                                                                     (answer-data (first l)))))
                                               (+ 2 (image-height (if (string? (answer-data (first l)))
                                                                      (font (answer-data (first l)))
                                                                      (answer-data (first l)))))
                                               "outline"
                                               "black"))
                           (posn-x (answer-loc (first l)))
                           (posn-y (answer-loc (first l)))
                           (draw-answers (rest l)))]))

(define (main-drawer m)
  (overlay (draw-scores m) (draw-question m) (draw-answers (question-answers (current-question m)))))

(define (draw-handler m)
  (cond [(not (equal? "" (topic-paragraph (current-topic m)))) (font (topic-paragraph (current-topic m)))]
        [else (main-drawer m)]))

(big-bang (start-game 2)
          (on-mouse mouse-handler)
          (on-receive receive-func)
          (register "127.0.0.1")
          (on-draw draw-handler 500 500))
