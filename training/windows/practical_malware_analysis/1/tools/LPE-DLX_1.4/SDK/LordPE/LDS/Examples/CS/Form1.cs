
/*****************************************************************************

  Little example for a LDS plugin in C#

  by yoda

*****************************************************************************/

using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Runtime.InteropServices;

namespace LDSChat
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Button butSend;
		private System.Windows.Forms.TextBox edSendText;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public Form1()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.label1 = new System.Windows.Forms.Label();
			this.edSendText = new System.Windows.Forms.TextBox();
			this.butSend = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 10);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(32, 16);
			this.label1.TabIndex = 0;
			this.label1.Text = "Text:";
			// 
			// edSendText
			// 
			this.edSendText.Location = new System.Drawing.Point(48, 7);
			this.edSendText.Name = "edSendText";
			this.edSendText.Size = new System.Drawing.Size(160, 20);
			this.edSendText.TabIndex = 1;
			this.edSendText.Text = "";
			this.edSendText.KeyDown += new System.Windows.Forms.KeyEventHandler(this.edSendText_KeyDown);
			// 
			// butSend
			// 
			this.butSend.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
			this.butSend.Location = new System.Drawing.Point(212, 7);
			this.butSend.Name = "butSend";
			this.butSend.Size = new System.Drawing.Size(56, 20);
			this.butSend.TabIndex = 2;
			this.butSend.Text = "Send";
			this.butSend.Click += new System.EventHandler(this.butSend_Click);
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(280, 37);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.butSend,
																		  this.edSendText,
																		  this.label1});
			this.Location = new System.Drawing.Point(200, 200);
			this.MaximizeBox = false;
			this.Name = "Form1";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "LDS Chat - C# LDS Plugin example";
			this.Load += new System.EventHandler(this.Form1_Load);
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static unsafe void Main() 
		{
			//
			// is LordPE Dumper Server active ?
			//
			if ( !LDS.IsLDSUp() )
			{
				MessageBox.Show("Please lunch LordPE's Dumper Server first !", "LordPE Plugin",
					MessageBoxButtons.OK, MessageBoxIcon.Error);
				return; // ERR
			}

			//
			// show window
			//
			Application.Run(new Form1());
		}

		public bool Str2LDS(string str)
		{
			LDS.LDS_LOG_ENTRY log;

			// LDS available ?
			if ( !LDS.IsLDSUp() )
				return false; // ERR

			// assign structure elements
			log.dwStructSize   = 0;
			log.szStr          = str.ToString();
			log.dwStrSize      = (uint)(str.Length + 1);
			log.bCatAtLast     = 0; // 0 = false
			log.dwStructSize   = (uint)Marshal.SizeOf( log );
			LDS.AddToLog( ref log );

			return true; // OK
		}

		public void SendText2LDS()
		{
			// sth entered ?
			if (edSendText.Text == "")
			{
				MessageBox.Show("Please enter something !", "ERROR",
					MessageBoxButtons.OK, MessageBoxIcon.Error);
				return;
			}
			// print
			if ( !Str2LDS( edSendText.Text ) )
			{
				MessageBox.Show("An error occurred !", "ERROR",
					MessageBoxButtons.OK, MessageBoxIcon.Error);
				return;
			}
			// clear edit
			edSendText.Text = "";
		}

		private void edSendText_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
		{
			if (e.KeyCode == Keys.Enter)
				SendText2LDS();
		}

		private void butSend_Click(object sender, System.EventArgs e)
		{
			SendText2LDS();
		}

		private void Form1_Load(object sender, System.EventArgs e)
		{
			// print plugin title to LDS
			Str2LDS("Plugin example for C# by yoda...");
		}
	}
}
