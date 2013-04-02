#include <gtk/gtk.h>

GtkWidget *window;

static void
activate_entry (GtkEntry *entry)
{
  GtkWidget *dialog;
  GError *error = NULL;
  const char *text = gtk_entry_get_text (entry);

  if (!g_spawn_command_line_async (text, &error))
    {
      dialog = gtk_message_dialog_new (GTK_WINDOW (window), 
				       GTK_DIALOG_DESTROY_WITH_PARENT,
				       GTK_MESSAGE_ERROR,
				       GTK_BUTTONS_CLOSE, 
				       "Can't run '%s': %s",
				       text, error->message);
      g_error_free (error);
      gtk_widget_show (dialog);
      g_signal_connect (dialog, "response", G_CALLBACK (gtk_widget_destroy), NULL);
    }
}

int
main (int argc, char *argv[])
{
  GtkWidget *entry;

  gtk_init (&argc, &argv);

  window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title (GTK_WINDOW (window), "Launcher");
  entry = gtk_entry_new ();
  gtk_container_add (GTK_CONTAINER (window), entry);
  gtk_widget_show_all (window);

  g_signal_connect (entry, "activate", G_CALLBACK (activate_entry), NULL);

  g_signal_connect (window, "destroy",
		    G_CALLBACK (gtk_main_quit),
		    NULL);
  g_signal_connect (window, "delete-event",
		    G_CALLBACK (gtk_false),
		    NULL);

  gtk_main ();

  return 0;
}
