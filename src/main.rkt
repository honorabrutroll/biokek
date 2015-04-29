;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
(require picturing-programs)
(require racket)
(provide all-defined-out)

(define molelist (list "Covalent Bonds" "Deoxyribose" "Hydrogen Bonds" "Hydroxyl Group" "Ionic Bonds" "Indicator" "Macromolecules" "Nutrient" "Phosphate Group" "Ribose" "SPONCHNaK" "Benzene" "Butane" "Chlorophyll"))
(define h2cellist (list "Organelles" "Higher Concentration" "Lower Concentration" "pH" "pOH" "Polarity of Water" "Diffusion" "Facilitated Diffusion" "Fermentation" "Gas Exchange" "Osmosis" "Calvin Cycle" "Dark Reaction" "De-hydrolysis" "Electron Transport Chain" "Energy Transfer"))
(define explist (list "Dependant Variable" "Experiment" "Homeostasis" "Independant Variable" "Neutral" "Organic" "Scientific Inquiry" "Standardized Variable"))
(define otherlist (list "Balanced Equation" "Catalyst" "Chemical Energy" "Chemical Equation" "Chloroplast" "Combustion"))
(define olist2 (list "Enzyme" "Heat Energy" "Hexagon" "Hydrogen Chain" "Hydrolysis" "Kinetic Energy" "Krebs Cycle" "Light Absorption" "Light Energy" "Light Reaction" "Methane" "Photosynthesis" "Pigment" "Potential Energy" "Product" "Reactant" "Super Charged Electron" "Yields"))
(define alllist (flatten (list molelist h2cellist explist otherlist olist2)))
alllist

