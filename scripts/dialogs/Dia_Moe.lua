function test_trade(_player, _npc)
	AI_StartTrade(_npc, _player);
	AI_ENDDIALOG(_npc);
end



function IMPORTENT_DIALOG(_player, _npc)
	AI_OUTPUT(_npc, _player, "DIA_Moe_Hallo_01_00.WAV", "Hey, ich kenne dich nicht. Was willst du hier? Willst du in die Kneipe?");
	ClearChoises(_npc);
	AddChoise(_npc, DIA_MOE_HALLO_GEHEN, nil, "Nein, ich will nicht in die Kneipe...(ENDE)");
	AddChoise(_npc, exit_dialog, nil, "Ach das hier ist die Kneipe... ");
	AddChoise(_npc, exit_dialog, nil, "Ja, hast du was dagegen?");
	
	AI_WAITFORCHOISES(_npc);
end

function DIA_MOE_HALLO_GEHEN(_player, _npc)
	AI_OUTPUT2(_npc, _player, _npc, "DIA_Moe_Hallo_Gehen_15_00.WAV", "Nein, ich will nicht in die Kneipe ...");
	AI_OUTPUT(_npc, _player, "DIA_Moe_Hallo_Gehen_01_01.WAV", "Ja, das hätte ich jetzt auch gesagt. Aber das ist nicht wichtig - und deshalb können wir direkt zum Geschäft kommen.");
	AI_OUTPUT(_npc, _player, "DIA_Moe_Hallo_Gehen_01_02.WAV", "Da du neu hier bist, mache ich dir ein Angebot. Du gibst mir 50 Goldstücke und kannst gehen.");
	AI_OUTPUT(_npc, _player, "DIA_Moe_Hallo_Gehen_01_03.WAV", "Das ist dein Eintrittspreis für die Kneipe.");
	
	ClearChoises(_npc);
	AddChoise(_npc, DIA_Moe_Hallo_Miliz, nil, "Wir können ja mal sehen, was die Miliz dazu sagt...");
	AddChoise(_npc, DIA_Moe_Hallo_Vergisses, nil, "Vergiss es, du kriegst nicht ein Goldstück!");
	AddChoise(_npc, DIA_Moe_Hallo_Zahlen, nil, "Okay, ich bezahle.");
	AddChoise(_npc, DIA_Moe_Hallo_Kneipe, nil, "Aber, ich will nicht in die Kneipe!");
	AI_WAITFORCHOISES(_npc);
end

function DIA_Moe_Hallo_Kneipe(_player, _npc)
	AI_OUTPUT2(_npc, _player, _npc, "DIA_Moe_Hallo_Kneipe_15_00.WAV", "Aber, ich will nicht in die Kneipe!");
	AI_OUTPUT(_npc, _player, "DIA_Moe_Hallo_Kneipe_01_01.WAV", "Weißt du, früher oder später will jeder mal in die Kneipe. Also kannst du auch direkt bezahlen - dann hast du es hinter dir.");
	AI_WAITFORCHOISES(_npc);
end

function DIA_Moe_Hallo_Miliz(_player, _npc)
	AI_OUTPUT2(_npc, _player, _npc, "DIA_Moe_Hallo_Miliz_15_00.WAV", "Wir können ja mal sehen, was die Miliz dazu sagt ...");
	AI_OUTPUT(_npc, _player, "DIA_Moe_Hallo_Miliz_01_01.WAV", "(lacht) Die Miliz ist nicht hier. Und weißt du auch, warum sie nicht hier ist?");
	AI_OUTPUT(_npc, _player, "DIA_Moe_Hallo_Miliz_01_02.WAV", "Das hier ist das Hafenviertel, Kleiner. Hier wird sich keiner von der Miliz mit mir anlegen.");
	AI_OUTPUT(_npc, _player, "DIA_Moe_Hallo_Miliz_01_03.WAV", "Die gehen höchstens in die 'Rote Laterne'. Du siehst, wir sind ganz unter uns. (grinst dreckig)");
	AI_WAITFORCHOISES(_npc);
end

function DIA_Moe_Hallo_Vergisses(_player, _npc)
	AI_OUTPUT2(_npc, _player, _npc, "DIA_Moe_Hallo_Vergisses_15_00.WAV", "Vergiss es, du kriegst nicht ein Goldstück!");
	AI_OUTPUT(_npc, _player, "DIA_Moe_Hallo_Vergisses_01_01.WAV", "Dann nehme ich mir halt alles, was du hast - sobald du im Staub vor mir liegst.");
	AI_ENDDIALOG(_npc);
	AI_SETENEMY(_npc, _player);
end

function DIA_Moe_Hallo_Zahlen(_player, _npc)
	AI_OUTPUT2(_npc, _player, _npc, "DIA_Moe_Hallo_Zahlen_15_00.WAV", "Okay, ich bezahle.");
	
	AI_HasItem(_npc, _player, "ITMI_GOLD", 50, DIA_Moe_Hallo_Zahlen_True, DIA_Moe_Hallo_Zahlen_False, {player=_player, npc=_npc});
end

function DIA_Moe_Hallo_Zahlen_True(arguments, item, amount)
	local _player = arguments["player"];
	local _npc = arguments["npc"];
	AI_OUTPUT(_npc, _player, "DIA_Moe_Hallo_Zahlen_01_01.WAV", "Na gut. Und weil das so gut geklappt hat, zahlst du mir jetzt noch den Rest, den du dabei hast.");
	AI_ENDDIALOG(_npc);
end

function DIA_Moe_Hallo_Zahlen_False(arguments, item, amount)
	local _player = arguments["player"];
	local _npc = arguments["npc"];
	AI_OUTPUT(_npc, _player, "DIA_Moe_Hallo_Zahlen_15_02.WAV", "... aber ich hab so viel Gold gerade nicht bei mir.");
	AI_OUTPUT(_npc, _player, "DIA_Moe_Hallo_Zahlen_01_03.WAV", "Das macht nichts. Dann gib mir einfach alles, was du dabei hast.");
	AI_ENDDIALOG(_npc);
end


function test_dialog(_player, _npc)
	AI_OUTPUT(_npc, _player, "DIA_Moe_Hallo_01_00", "Hey, ich kenne dich nicht. Was willst du hier? Willst du in die Kneipe?");
	ClearChoises(_npc);
	AddChoise(_npc, exit_dialog, nil, "Exit");
	AI_WAITFORCHOISES(_npc);
end

function exit_dialog(_player, _npc)
	AI_ENDDIALOG(_npc);
end