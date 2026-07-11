#include 'totvs.ch'
#include 'fwmvcdef.ch

Static Function menudef()

		ADD OPTION aRotina Title 'Pesquisar'  		Action 'PesqBrw'			OPERATION OP_PESQUISAR 		ACCESS 0
		if oMainBrw:Alias() == 'SC5'
			ADD OPTION aRotina Title 'Visualizar' 		Action 'A410Visual'		OPERATION OP_VISUALIZAR 	ACCESS 0
			ADD OPTION aRotina Title 'Define Transp'	Action 'u_LDefTran'		OPERATION OP_ALTERAR 		ACCESS 0
			ADD OPTION aRotina Title 'Tracking'			Action 'u_LTracking'	OPERATION OP_VISUALIZAR		ACCESS 0
		elseif oMainBrw:Alias() == 'SF2'
			ADD OPTION aRotina Title 'Visualizar' 		Action 'a920NFSAI'		OPERATION OP_VISUALIZAR 	ACCESS 0
			ADD OPTION aRotina Title 'Envia XML'		Action 'u_LSendNFs'		OPERATION OP_ALTERAR 		ACCESS 0
			ADD OPTION aRotina Title 'Tracking'			Action 'u_LTracking'	OPERATION OP_VISUALIZAR		ACCESS 0
		else
			ADD OPTION aRotina Title 'Detalhes Log' 		Action 'axVisual'		OPERATION OP_VISUALIZAR 	ACCESS 0
			ADD OPTION aRotina Title 'Visualizar Doc' 		Action 'u_LViewCte'		OPERATION OP_VISUALIZAR 	ACCESS 0
		endif
//		ADD OPTION aRotina Title 'Legenda'    		Action 'U_MANREPLE()'   OPERATION 8 ACCESS 0

Return aRotina 
