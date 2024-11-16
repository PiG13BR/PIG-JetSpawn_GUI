class PIG_RscJetMenu
{
	idd = 8888;
	movingEnable = true;
    controlsBackground[] = {};
	onLoad = "";
	onUnload = "";
	class controls
	{
		class RscFrame_1800: RscFrame
		{
			idc = -1;
			type = CT_STATIC;
			style = ST_BACKGROUND;
			x = 0.0342279 * safezoneW + safezoneX;
			y = 0.219937 * safezoneH + safezoneY;
			w = 0.170564 * safezoneW;
			h = 0.69215 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.8};
		};
		class RscFrame_1801: RscFrame
		{
			idc = -1;
			type = CT_STATIC;
			style = ST_BACKGROUND;

			x = 0.775527 * safezoneW + safezoneX;
			y = 0.177928 * safezoneH + safezoneY;
			w = 0.203365 * safezoneW;
			h = 0.4481 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.8};
		};
		class RscCombo_1500: RscCombo
		{
			idc = 1500;

			x = 0.395037 * safezoneW + safezoneX;
			y = 0.107913 * safezoneH + safezoneY;
			w = 0.196805 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscListbox_1501: RscListBox
		{
			idc = 1501;

			x = 0.0473485 * safezoneW + safezoneX;
			y = 0.27595 * safezoneH + safezoneY;
			w = 0.144324 * safezoneW;
			h = 0.266059 * safezoneH;
		};
		class RscListbox_1502: RscListBox
		{
			idc = 1502;

			x = 0.0539086 * safezoneW + safezoneX;
			y = 0.612025 * safezoneH + safezoneY;
			w = 0.131203 * safezoneW;
			h = 0.266059 * safezoneH;
		};
		class RscListbox_1503: RscListBox
		{
			idc = 1503;

			x = 0.788647 * safezoneW + safezoneX;
			y = 0.247944 * safezoneH + safezoneY;
			w = 0.104963 * safezoneW;
			h = 0.266059 * safezoneH;
		};
		class RscButton_1600: RscButton
		{
			idc = 1600;
			action = "";

			text = "Spawn"; //--- ToDo: Localize;
			x = 0.834569 * safezoneW + safezoneX;
			y = 0.654034 * safezoneH + safezoneY;
			w = 0.0918423 * safezoneW;
			h = 0.0560125 * safezoneH;
		};
		class RscButton_1601: RscButton
		{
			idc = 1601;

			text = "Save"; //--- ToDo: Localize;
			x = 0.90017 * safezoneW + safezoneX;
			y = 0.247944 * safezoneH + safezoneY;
			w = 0.0656017 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscButton_1602: RscButton
		{
			idc = 1602;

			text = "Load"; //--- ToDo: Localize;
			x = 0.90017 * safezoneW + safezoneX;
			y = 0.289953 * safezoneH + safezoneY;
			w = 0.0656017 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscButton_1603: RscButton
		{
			idc = 1603;

			text = "Delete"; //--- ToDo: Localize;
			x = 0.90017 * safezoneW + safezoneX;
			y = 0.331963 * safezoneH + safezoneY;
			w = 0.0656017 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscButton_1604: RscButton
		{
			idc = 1604;

			text = "Rename"; //--- ToDo: Localize;
			x = 0.90673 * safezoneW + safezoneX;
			y = 0.528006 * safezoneH + safezoneY;
			w = 0.0656017 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscButton_1605: RscButton
		{
			idc = 1605;

			text = "Save new preset"; //--- ToDo: Localize;
			x = 0.801768 * safezoneW + safezoneX;
			y = 0.570016 * safezoneH + safezoneY;
			w = 0.0918423 * safezoneW;
			h = 0.0420094 * safezoneH;
		};
		class RscButton_1606: RscButton
		{
			idc = 1606;
			text = "Change Angle"; //--- ToDo: Localize;
			x = 0.454079 * safezoneW + safezoneX;
			y = 0.878084 * safezoneH + safezoneY;
			w = 0.104963 * safezoneW;
			h = 0.0420094 * safezoneH;
		};
		class RscText_1000: RscText
		{
			idc = 1000;
			style = ST_CENTER;

			text = "Jet Spawn Menu"; //--- ToDo: Localize;
			x = 0.349117 * safezoneW + safezoneX;
			y = 0.0238938 * safezoneH + safezoneY;
			w = 0.288647 * safezoneW;
			h = 0.0420094 * safezoneH;
			sizeEx = 0.08;
		};
		class RscText_1001: RscText
		{
			idc = 1001;
			style = ST_RIGHT;

			text = "Airplanes:"; //--- ToDo: Localize;
			x = 0.257274 * safezoneW + safezoneX;
			y = 0.107913 * safezoneH + safezoneY;
			w = 0.131203 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscText_1002: RscText
		{
			idc = 1002;
			style = ST_CENTER;

			text = "Pylons"; //--- ToDo: Localize;
			x = 0.0473485 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.144324 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscText_1003: RscText
		{
			idc = 1003;
			style = ST_CENTER;

			text = "Ammunition"; //--- ToDo: Localize;
			x = 0.0539086 * safezoneW + safezoneX;
			y = 0.570016 * safezoneH + safezoneY;
			w = 0.131203 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscText_1004: RscText
		{
			idc = 1004;
			style = ST_CENTER;
			text = "Presets"; //--- ToDo: Localize;
			x = 0.788647 * safezoneW + safezoneX;
			y = 0.191931 * safezoneH + safezoneY;
			w = 0.177125 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscEdit_1400: RscEdit
		{
			idc = 1400;

			x = 0.788647 * safezoneW + safezoneX;
			y = 0.528006 * safezoneH + safezoneY;
			w = 0.111523 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
	}
}
