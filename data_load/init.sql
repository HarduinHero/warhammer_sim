DROP TABLE IF EXISTS Datasheets_leader;
DROP TABLE IF EXISTS Datasheets_detachment_abilities;
DROP TABLE IF EXISTS Datasheets_enhancements;
DROP TABLE IF EXISTS Datasheets_stratagems;
DROP TABLE IF EXISTS Datasheets_models_cost;
DROP TABLE IF EXISTS Datasheets_unit_composition;
DROP TABLE IF EXISTS Datasheets_wargear;
DROP TABLE IF EXISTS Datasheets_options;
DROP TABLE IF EXISTS Datasheets_models;
DROP TABLE IF EXISTS Datasheets_keywords;
DROP TABLE IF EXISTS Datasheets_abilities;
DROP TABLE IF EXISTS Datasheets;
DROP TABLE IF EXISTS Detachment_abilities;
DROP TABLE IF EXISTS Enhancements;
DROP TABLE IF EXISTS Stratagems;
DROP TABLE IF EXISTS Detachments;
DROP TABLE IF EXISTS Abilities;
DROP TABLE IF EXISTS Source;
DROP TABLE IF EXISTS Factions;


CREATE TABLE Factions ( --File contains a table of factions and subfactions
    id TEXT, --Faction identifier. Used to link to other tables
    "name" TEXT, --Faction name
    link TEXT, --Link to the faction page on the Wahapedia website

    CONSTRAINT FACTIONS_PK PRIMARY KEY (id)
);

CREATE TABLE Source ( --The file contains a table of add-ons (supplements, rulebooks, promo datasheets, etc.)
    id TEXT, --Add-on identifier. Used to link to other tables
    "name" TEXT, --Add-on name
    "type" TEXT, --Add-on type ("Index", "Supplement", etc.)
    "edition" TEXT, --Edition number
    "version" TEXT, --Errata version number
    errata_date TEXT, --Date of the latest errata (if there is no erratas, then the date of announcement / release)
    errata_link TEXT, --Link to errata / source on GW website

    CONSTRAINT SOURCE_PK PRIMARY KEY (id)
);

CREATE TABLE Abilities ( --The file contains the Abilities table
    id TEXT, --Abilities identifier. Used to link to other tables
    "name" TEXT, --Ability name
    legend TEXT, --Ability background
    faction_id TEXT, --Faction ID (link to Factions.csv table)
    "description" TEXT, --Ability description

    CONSTRAINT ABILITIES_PK PRIMARY KEY(id, faction_id),
    CONSTRAINT ABILITIES_FACTIONS_FK FOREIGN KEY(faction_id) REFERENCES Factions(id)
);

CREATE TABLE Detachments ( --The file contains the Detachments table
    id TEXT, --Detachment identifier. Used to link to other tables
    faction_id TEXT, --Faction ID (link to Factions.csv table)
    "name" TEXT, --Detachment name
    legend TEXT, --Detachment legend
    "type" TEXT, --Detachment type (e.g. "Boarding Action")

    CONSTRAINT DETACHMENTS_PK PRIMARY KEY(id, faction_id),
    CONSTRAINT DETACHMENTS_FACTIONS_FK FOREIGN KEY(faction_id) REFERENCES Factions(id)
);

CREATE TABLE Stratagems ( --File contains table of Stratagems
    id TEXT, --Stratagem identifier. Used to link to other tables
    faction_id TEXT, --Faction ID (link to Factions.csv table)
    "name" TEXT, --Stratagem name
    "type" TEXT, --Stratagem type (eg Shield Host – Strategic Ploy Stratagem)
    cp_cost TEXT, --Stratagem command point cost
    legend TEXT, --Stratagem background
    turn TEXT, --Stratagem turn
    phase TEXT, --Stratagem phase
    "description" TEXT, --Stratagem description
    detachment TEXT, --Detachment name
    detachment_id TEXT, --Detachment ID (link to Detachments.csv table)

    CONSTRAINT STRATAGEMS_PK PRIMARY KEY(id, faction_id, detachment_id),
    CONSTRAINT STRATAGEMS_FACTIONS_FK FOREIGN KEY(faction_id) REFERENCES Factions(id),
    CONSTRAINT STRATAGEMS_DETACHMENTS_FK FOREIGN KEY(detachment_id) REFERENCES Detachments(id)
);

CREATE TABLE Enhancements ( --The file contains the Enhancements table
    id TEXT, --Enhancements identifier. Used to link to other tables
    faction_id TEXT, --Faction ID (link to Factions.csv table)
    "name" TEXT, --Enhancement name
    legend TEXT, --Enhancement legend
    "description" TEXT, --Enhancement description
    cost TEXT, --Enhancement points cost
    detachment TEXT, --Detachment name
    detachment_id TEXT, --Detachment ID (link to Detachments.csv table)

    CONSTRAINT ENHANCEMENTS_PK PRIMARY KEY(id, faction_id, detachment_id),
    CONSTRAINT ENHANCEMENTS_FACTIONS_FK FOREIGN KEY(faction_id) REFERENCES Factions(id),
    CONSTRAINT ENHANCEMENTS_DETACHMENTS_FK FOREIGN KEY(detachment_id) REFERENCES Detachments(id)
);

CREATE TABLE Detachment_abilities ( --The file contains the Detachment abilities table
    id TEXT, --Detachment abilities identifier. Used to link to other tables
    faction_id TEXT, --Faction ID (link to Factions.csv table)
    "name" TEXT, --Detachment ability name
    legend TEXT, --Detachment ability legend
    "description" TEXT, --Detachment ability description
    detachment TEXT, --Detachment name
    detachment_id TEXT, --Detachment ID (link to Detachments.csv table)

    CONSTRAINT DETACHMENTABILITIES_PK PRIMARY KEY(id, faction_id, detachment_id),
    CONSTRAINT DETACHMENTABILITIES_FACTIONS_FK FOREIGN KEY(faction_id) REFERENCES Factions(id),
    CONSTRAINT DETACHMENTABILITIES_DETACHMENTS_FK FOREIGN KEY(detachment_id) REFERENCES Detachments(id)
);

CREATE TABLE Datasheets ( --File contains a table of datasheets
    id TEXT, --Datasheet identifier. Used to link to other tables
    "name" TEXT, --Datasheet name
    faction_id TEXT, --Faction ID (link to Factions.csv table)
    source_id TEXT, --Add-on ID (link to Source.csv table)
    legend TEXT, --Datasheet’s background
    "role" TEXT, --Datasheet’s Battlefield Role
    loadout TEXT, --Datasheet loadout
    transport TEXT, --Transport capacity (if it is a TRANSPORT)
    virtual INTEGER, --Virtual datasheets not present in army list but can be summoned in some cases (eg Chaos Spawn)
    leader_head TEXT, --Leader section header commentary
    leader_footer TEXT, --Leader section footer commentary
    damaged_w TEXT, --Remaining Wounds count
    damaged_description TEXT, --Remaining Wounds description
    link TEXT, --Link to datasheet on the Wahapedia website

    CONSTRAINT DATASHEET_PK PRIMARY KEY (id),
    CONSTRAINT DATASHEET_FACTIONS_FK FOREIGN KEY(faction_id) REFERENCES Factions(id),
    CONSTRAINT DATASHEET_SOURCE_FK FOREIGN KEY(source_id) REFERENCES Source(id)
);

CREATE TABLE Datasheets_abilities ( --The file contains a table of the Abilities of the datasheets
    datasheet_id TEXT, --Datasheet identifier (link to the Datasheets.csv table)
    "line" TEXT, --Line number in the table (starting from 1)
    ability_id TEXT, --Ability ID (link to Abilities.csv table). If filled use Ability name, description, type and parameter from Abilities.csv
    model TEXT, --Belonging of this ability to a specific model of the datasheet
    "name" TEXT, --Ability name
    "description" TEXT, --Ability description
    "type" TEXT, --Ability type
    parameter TEXT, --Ability parameter

    CONSTRAINT DATASHEETABILITIES_DATASHEET_FK FOREIGN KEY(datasheet_id) REFERENCES Datasheets(id),
    CONSTRAINT DATASHEETABILITIES_ABILITIES_FK FOREIGN KEY(ability_id) REFERENCES Abilities(id)
);

CREATE TABLE Datasheets_keywords ( --The file contains a table of the Keywords of the datasheets
    datasheet_id TEXT, --Datasheet identifier (link to the Datasheets.csv table)
    keyword TEXT, --Datasheet keyword
    model TEXT, --Belonging of this keyword to a specific model of the datasheet
    is_faction_keyword INTEGER, --This is a Faction Keyword

    CONSTRAINT DATASHEETSKEYWORD_DATASHEET_FK FOREIGN KEY(datasheet_id) REFERENCES Datasheets(id)
);

CREATE TABLE Datasheets_models ( --The file contains a table of models included in datasheets
    datasheet_id TEXT, --Datasheet identifier (link to the Datasheets.csv table)
    "line" TEXT, --Line number in the table (starting from 1)
    "name" TEXT, --Model name
    M TEXT, --Move chatacteristic
    T TEXT, --Toughness chatacteristic
    Sv TEXT, --Save chatacteristic
    inv_sv TEXT, --Invulnerable Save chatacteristic
    inv_sv_descr TEXT, --Invulnerable Save commentary
    W TEXT, --Wounds chatacteristic
    Ld TEXT, --Leadership chatacteristic
    OC TEXT, --Objective Control chatacteristic
    base_size TEXT, --Model base size
    base_size_descr TEXT, --Model base size commentary

    CONSTRAINT DATASHEETSMODELS_DATASHEET_FK FOREIGN KEY(datasheet_id) REFERENCES Datasheets(id)
);

CREATE TABLE Datasheets_options ( --The file contains a table of Wargear Options of datasheets
    datasheet_id TEXT, --Datasheet identifier (link to the Datasheets.csv table)
    "line" TEXT, --Line number in the table (starting from 1)
    button TEXT, --Decorative symbol at the beginning of an option
    "description" TEXT, --Wargear option description

    CONSTRAINT DATASHEETSOPTIONS_DATASHEET_FK FOREIGN KEY(datasheet_id) REFERENCES Datasheets(id)
);
 
CREATE TABLE Datasheets_wargear ( --The file contains a table of datasheet’s Wargear
    datasheet_id TEXT, --Datasheet identifier (link to the Datasheets.csv table)
    "line" TEXT, --Line number in the table (starting from 1)
    line_in_wargear TEXT, --Line number in Wargear.csv table (use ORDER BY line, line_in_wargear to sort out wargear lines)
    dice TEXT, --Dice result required (see Bubblechukka)
    "name" TEXT, --Wargear name
    "description" TEXT, --Wargear rules
    "range" TEXT, --Range characteristic
    "type" TEXT, --Type characteristic ("Melee", "Range")
    A TEXT, --Attacks characteristic
    BS_WS TEXT, --Ballistic/Weapon Skill characteristic
    S TEXT, --Strength characteristic
    AP TEXT, --Armour Penetration characteristic
    D TEXT, --Damage characteristic

    CONSTRAINT DATASHEETSWARGEAR_DATASHEET_FK FOREIGN KEY(datasheet_id) REFERENCES Datasheets(id)
);

CREATE TABLE Datasheets_unit_composition ( --The file contains a table of datasheet’s unit composition
    datasheet_id TEXT, --Datasheet identifier (link to the Datasheets.csv table)
    "line" TEXT, --Line number in the table (starting from 1)
    "description" TEXT, --Unit composition

    CONSTRAINT DATASHEETSUNITCOMPOSITION_DATASHEET_FK FOREIGN KEY(datasheet_id) REFERENCES Datasheets(id)
);

CREATE TABLE Datasheets_models_cost ( --The file contains a table of datasheet’s models cost
    datasheet_id TEXT, --Datasheet identifier (link to the Datasheets.csv table)
    "line" TEXT, --Line number in the table (starting from 1)
    "description" TEXT, --Model description
    cost TEXT, --Model cost

    CONSTRAINT DATASHEETSMODELSCOST_DATASHEET_FK FOREIGN KEY(datasheet_id) REFERENCES Datasheets(id)
);

CREATE TABLE Datasheets_stratagems ( --The file contains a table of datasheet’s Stratagems
    datasheet_id TEXT, --Datasheet identifier (link to the Datasheets.csv table)
    stratagem_id TEXT, --Stratagem identifier (link to the Stratagems.csv table)

    CONSTRAINT DATASHEETSTRATAGEM_DATASHEET_FK FOREIGN KEY(datasheet_id) REFERENCES Datasheets(id),
    CONSTRAINT DATASHEETSTRATAGEM_FACTIONS_FK FOREIGN KEY(stratagem_id) REFERENCES Stratagems(id)
);

CREATE TABLE Datasheets_enhancements ( --The file contains a table of datasheet’s Enhancements
    datasheet_id TEXT, --Datasheet identifier (link to the Datasheets.csv table)
    enhancement_id TEXT, --Enhancement identifier (link to the Enhancements.csv table)

    CONSTRAINT DATASHEETSENHANCEMENT_DATASHEET_FK FOREIGN KEY(datasheet_id) REFERENCES Datasheets(id),
    CONSTRAINT DATASHEETSENHANCEMENT_ENHANCEMENTS_FK FOREIGN KEY(enhancement_id) REFERENCES Enhancements(id)
);

CREATE TABLE Datasheets_detachment_abilities ( --The file contains a table of datasheet’s Detachment abilities
    datasheet_id TEXT, --Datasheet identifier (link to the Datasheets.csv table)
    detachment_ability_id TEXT, --Detachment ability identifier (link to the Detachment_abilities.csv table)

    CONSTRAINT DATASHEETSDETACHMENTABILITIES_DATASHEET_FK FOREIGN KEY(datasheet_id) REFERENCES Datasheets(id),
    CONSTRAINT DATASHEETSDETACHMENTABILITIES_DETACHMENTABILITY_FK FOREIGN KEY(detachment_ability_id) REFERENCES Detachment_abilities(id)
);

CREATE TABLE Datasheets_leader ( --The file contains a table of datasheet’s Leaders
    leader_id TEXT, --Datasheet identifier (link to the Datasheets.csv table)
    attached_id TEXT, --Attached datasheet identifier (link to the Datasheets.csv table)

    CONSTRAINT DATASHEETSLEADER_DATASHEET_FK FOREIGN KEY(leader_id) REFERENCES Datasheets(id),
    CONSTRAINT DATASHEETSLEADER_DATASHEET_FK FOREIGN KEY(attached_id) REFERENCES Datasheets(id)
);