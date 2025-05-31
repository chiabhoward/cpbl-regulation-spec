# CPBL Regulation Specification

This project contains a TLA+ specification that models the regulation of Chinese Professional Baseball League (CPBL) in 2020.

## Overview

This specification uses TLA+ to formally model and analyze:
- The structure of the league (e.g., teams, schedule, seasons)
- Game outcomes (win, loss, tie)
- Conditions for team elimination and playoff qualification

## Key Concepts Modeled

- **Win rate calculations**
- **Head-to-head comparisons**
- **Season breakdowns (e.g., first-half, second-half, overall)**
- **Team elimination logic**

## How to Run

To check the spec with the TLC model checker:
1. Install [TLA+ Toolbox](https://lamport.azurewebsites.net/tla/toolbox.html).
2. Open `CPBL.tla` in TLA+ Toolbox.
3. Configure the initial predicate, next-state relation, invariants, and values of declared constants in the 'Model Overview' section.
4. Run the model checker to verify correctness or simulate execution traces.

## Example Inputs

The defined values in `CPBL.tla` and the inputs below correspond to the scenario described in this [video](https://www.youtube.com/watch?v=6Vgn82anQhs&t=60s).
- Set `Init` in the **Init** field.
- Set `Next` in the **Next** field.
- Add `Invariant1` and `Invariant2` to the **Invariants** field.
- Initialize the constants with the following values:
  ```
  Teams <- {"B", "L", "G", "R"}
  TotalGames <- 60
  Winner <- "B"
  Schedule <- << << "L", "G" >>, << "B", "R" >>, << "B", "R" >>, << "B", "G" >>, << "G", "R" >>, << "L", "G" >>, << "B", "L" >> >>
  ```



## Limitations

- Assumes fixed number of teams and team names
- Simplified elimination rules

## Feedback

Feel free to open an issue or reach out if you have suggestions, bug reports, or are interested in collaborating on extending this model!
