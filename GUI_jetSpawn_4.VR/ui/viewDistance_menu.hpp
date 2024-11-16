class PIG_RscViewDistance
{
	idd = -1;
	movingEnable = true;
    controlsBackground[] = {};
	class controls
	{
		class RscSlider_1900: RscSlider
		{
			idc = 1900;
			type = CT_XSLIDER;
			color[] = {1,1,1,0.6};
			colorDisable[] = {1,1,1,0.4};
			style = "0x400 + 0x10";
			colorDisabled[] = {1,1,1,0.2};
			arrowEmpty = "\A3\ui_f\data\gui\cfg\slider\arrowEmpty_ca.paa";
			arrowFull = "\A3\ui_f\data\gui\cfg\slider\arrowFull_ca.paa";
			border = "\A3\ui_f\data\gui\cfg\slider\border_ca.paa";
			thumb = "\A3\ui_f\data\gui\cfg\slider\thumb_ca.paa";
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};

			x = 0.440958 * safezoneW + safezoneX;
			y = 0.471994 * safezoneH + safezoneY;
			w = 0.183685 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscText_1000: RscText
		{
			idc = 1000;

			text = "Visão de Distância";
			x = 0.290075 * safezoneW + safezoneX;
			y = 0.471994 * safezoneH + safezoneY;
			w = 0.137764 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscEdit_1400: RscEdit
		{
			idc = 1400;
			autocomplete = 0;
			maxChars = 6;

			x = 0.644324 * safezoneW + safezoneX;
			y = 0.471994 * safezoneH + safezoneY;
			w = 0.0524813 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscText_1001: RscText
		{
			idc = 1000;

			text = "Visão de Distância (Objetos)";
			x = 0.290075 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.137764 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscSlider_1901: RscSlider
		{
			idc = 1901;
			type = CT_XSLIDER;
			color[] = {1,1,1,0.6};
			colorDisable[] = {1,1,1,0.4};
			style = "0x400 + 0x10";
			colorDisabled[] = {1,1,1,0.2};
			arrowEmpty = "\A3\ui_f\data\gui\cfg\slider\arrowEmpty_ca.paa";
			arrowFull = "\A3\ui_f\data\gui\cfg\slider\arrowFull_ca.paa";
			border = "\A3\ui_f\data\gui\cfg\slider\border_ca.paa";
			thumb = "\A3\ui_f\data\gui\cfg\slider\thumb_ca.paa";
			tooltipColorText[] = {1,1,1,1};
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};

			x = 0.440958 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.183685 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class RscEdit_1401: RscEdit
		{
			idc = 1401;
			autocomplete = 0;
			maxChars = 6;

			x = 0.644324 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.0524813 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
	}
}







